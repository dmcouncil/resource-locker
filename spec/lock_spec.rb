require 'spec_helper'
require 'pry'

describe 'The Resource Locker App' do

  let!(:resource) { Resource.create(name: 'lockable-resource') }

  def app
    Sinatra::Application
  end

  it "Returns a list of possible resources for no params" do
    post '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq("You can use this to lock #{Resource.all.map(&:name).join(', ')}")
  end

  it 'rejects the request with a bad token error' do
    post '/', { token: 'not-the-token' }
    expect(last_response).not_to be_ok
  end

  context 'when the request is for a bad resource' do
    it 'returns "is not available for locking"' do
      post '/', { token: ENV['SLACK_REQUEST_TOKEN'], text: 'not-a-resource', user_name: 'test-user',  }
      expect(last_response).to be_ok
      expect(last_response.body).to eq("Resource not-a-resource is not available for locking.")
    end
  end

  context 'with no existing locks' do
    let(:expected_json) { { response_type: 'in_channel', text: 'lockable-resource is locked by test-user for another 10 minutes' }.to_json }

    it 'returns "is not locked" when no time is requested' do
      post '/', { token: ENV['SLACK_REQUEST_TOKEN'], text: 'lockable-resource', user_name: 'test-user', response_url: 'http://example.com/test' }
      expect(last_response).to be_ok
      expect(last_response.body).to eq("lockable-resource is not locked")
    end

    it 'returns a JSON lock message when time is requested' do
      post '/', { token: ENV['SLACK_REQUEST_TOKEN'], text: 'lockable-resource 10', user_name: 'test-user', response_url: 'http://example.com/test' }
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_json)
    end
  end

  context 'when the resource is locked' do
    let!(:resource) do
      resource = Resource.create(name: 'locked-thing')
      resource.lock('testy-user', 10)
      resource
    end
    let(:expected_json) { { response_type: 'in_channel', text: 'locked-thing is locked by testy-user for another 15 minutes' }.to_json }

    it 'returns a message indicating the length of the lock when no time is requested' do
      post '/', { token: ENV['SLACK_REQUEST_TOKEN'], text: 'locked-thing', user_name: 'testy-user', response_url: 'http://example.com/text' }
      expect(last_response).to be_ok
      expect(last_response.body).to eq('locked-thing is locked by testy-user for another 10 minutes')
    end

    it 'returns a message indicating the remaining time and lock owner when time is requested by another user' do
      post '/', { token: ENV['SLACK_REQUEST_TOKEN'], text: 'locked-thing 15', user_name: 'another-user', response_url: 'http://example.com/text' }
      expect(last_response).to be_ok
      expect(last_response.body).to eq({ text: 'locked-thing is locked by testy-user for another 10 minutes' }.to_json)
    end

    it 'extends the lock when time is requested by the lock owner' do
      post '/', { token: ENV['SLACK_REQUEST_TOKEN'], text: 'locked-thing 15', user_name: 'testy-user', response_url: 'http://example.com/text' }
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_json)
    end
  end
end
