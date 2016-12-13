require 'spec_helper'
require 'pry'

describe 'resource management' do

  let!(:resource) { Resource.create(name: 'indexed-resource') }

  def app
    Sinatra::Application
  end

  it "Returns a list of available resources and a form for creation" do
    get '/resources'
    expect(last_response).to be_ok
    expect(last_response.body).to match(/<ul>/)
    expect(last_response.body).to match(/<li class='resource'>/)
    expect(last_response.body).to match(/<input name='resource\[name\]' placeholder='resource-name \(case sensitive, no spaces\)' size='50' type='text'>/)
  end

  it "Creates resources" do
    resource_count = Resource.count
    post '/resources', { resource: { name: 'new-resource' } }
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_response.body).to match(/<h2>Available Resources<\/h2>/)
    expect(last_response.body).to match(/new\-resource/)
    expect(Resource.count).to eq (resource_count + 1)
  end

  it "Deletes resources" do
    resource_count = Resource.count
    post "/resources/#{resource.id}", { "_method": "delete" }
    expect(last_response).to be_redirect
    follow_redirect!
    expect(Resource.count).to eq (resource_count - 1)    
  end

end