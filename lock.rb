require 'sinatra'
require 'sinatra/activerecord'
require './app/models/resource'

post '/' do
  return [400, ["Bad token"]] unless request['token'] == ENV['SLACK_REQUEST_TOKEN']
  resource_name, duration = request['text'].split unless request['text'].blank?
  if resource_name.blank?
    # Return resources available
    return [200, ["You can use this to lock #{Resource.all.map(&:name).join(', ')}"]]
  end
  resource = Resource.find_by_name(resource_name)
  if resource && duration.blank?
    # Return status of the resource
    return [200, [resource.status_string]]
  elsif resource
    # lock resource for duration
    response = {}
    if resource.lock(request['user_name'], duration)
      response[:response_type] = 'in_channel' # Announce a new lock
    end
    response[:text] = resource.status_string

    status 200
    headers 'Content-type' => 'application/json'
    body response.to_json
  else
    # Couldn't find the resource
    return [200, ["Resource #{resource_name} is not available for locking."]]
  end
end