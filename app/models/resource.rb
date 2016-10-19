class Resource < ActiveRecord::Base
  def lock(user, duration)
    return false if locked? && self.locked_by != user
    duration = [duration.to_i, 600].min # Lock length is capped
    self.locked_by = user
    self.locked_until = Time.now + (duration * 60) # Convert minutes to seconds
    self.save
  end

  def status_string
    if locked?
      return "#{self.name} is locked by #{self.locked_by} for another #{minutes_remaining} minutes"
    else
      return "#{self.name} is not locked"
    end
  end

  private

  def locked?
    return false if self.locked_until.nil?
    return locked_until > Time.now
  end

  def minutes_remaining
    return 0 unless locked?
    ((locked_until - Time.now)/60).to_i + 1
  end
end