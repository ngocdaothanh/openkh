class Conf < ActiveRecord::Base
  def self.instance
    ret = first
    if ret.nil?
      ret = new
      ret.save
    end
    ret
  end

  def to_param
    sanitize_to_param("#{id}-#{type}")
  end
end
