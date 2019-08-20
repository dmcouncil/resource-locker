require 'excon'

class Message
  def self.schedule_release_notification(request, resource, duration)
    response_url = request['response_url']
    message = {}
    message[:text] = lock_owner_released_message(resource)
    message[:post_at] = get_lock_release_time(duration).to_i
    Excon.new(response_url).post(message)
  end

  private

  def self.get_lock_release_time(duration)
    Time.now + (duration.to_i * 60)
  end

  def self.lock_owner_released_message(resource)
    "Your lock for #{resource.name} has expired. Use `/lock #{resource.name}` to check if it has been locked by another user, or use `/lock #{resource.name} 30` to create a new lock for 30 minutes."
  end
end
