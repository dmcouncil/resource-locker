require 'spec_helper'

describe 'The Resource Locker App' do

  def app
    Sinatra::Application
  end

  it "Returns a list of possible resources for no params" do
    post '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq("You can use this to lock #{Resource.all.map(&:name).join(', ')}")
  end

  context 'with no existing locks' do
    it 'returns "is not locked" when no time is requested' do
    end

    it 'returns a JSON lock message when time is requested' do
    end
  end

  context 'when the resource is locked' do
    # Set up a locked resource
    it 'returns a message indicating the length of the lock when no time is requested' do
    end

    it 'returns a message indicating the remaining time and lock owner when time is requested by another user' do
    end

    it 'extends the lock when time is requested by the lock owner' do
    end
  end
end