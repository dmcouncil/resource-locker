class Resource < ActiveRecord::Base
  def locked?
    return false if self.locked_until.nil?
    # locked_until comes back as 2000-01-01, so we need to ignore dates when comparing
    locked_local = Time.now.dst? ? (self.locked_until.getlocal + 3600) : self.locked_until.getlocal
    return locked_local > Time.new(2000, 1, 1, Time.now.hour, Time.now.min)
  end

  def lock(user, duration)
    # TODO: cap the duration of a lock - e.g. 600 is 10 hours
    return false if locked?
    self.locked_by = user
    self.locked_until = Time.now + (duration.to_i * 60) # Convert minutes to seconds
    self.save
  end

  def status_string
    if self.locked?
      return "#{self.name} is locked by #{self.locked_by} until #{locked_string}"
    else
      return "#{self.name} is not locked as of #{Time.now.strftime '%H:%M'}"
    end
  end

  private

  def locked_string
    if Time.now.dst?
      (locked_until.getlocal + 3600).strftime "%l:%M"
    else
      locked_until.getlocal.strftime "%l:%M"
    end
  end
end