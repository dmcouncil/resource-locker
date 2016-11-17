require 'spec_helper'

describe 'The Resource Locker App' do

  def app
    Sinatra::Application
  end

  it "Returns an error for no parameters" do
    post '/'
    binding.pry
    expect(last_response).not_to be_ok
    expect(last_response.body).to eq('Bad token')
  end
end