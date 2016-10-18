require 'sinatra'
require 'sinatra/activerecord'
require './app/models/resource'

post '/' do
  return [400, ["Bad token"]] unless request['token'] == 'hYdeXb5WxvEtWPQMGyRN9cOB'
  resource_name, duration = request['text'].split unless request['text'].blank?
  if resource_name.blank?
    return [200, [Resource.all.map(&:name).join(', ')]]
  end
  # Get resource by resource_name
  resource = Resource.find_by_name(resource_name)
  if resource && duration.blank?
    return [200, [resource.status_string]]
  elsif resource
    # lock resource for duration
    response = {}
    if resource.lock(request['user_name'], duration)
      response[:response_type] = 'in-channel'
    end
    response[:text] = resource.status_string

    status 200
    headers 'Content-type' => 'application/json'
    body response.to_json
  else
    return [200, ["Resource #{resource_name} is not available for locking."]]
  end
end