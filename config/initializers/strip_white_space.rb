# StripAttributes is also a good solution:
# http://agilewebdevelopment.com/plugins/stripattributes
ActiveRecord::Base.class_eval do
  before_validation :strip_white_space

  def strip_white_space
    self.attributes.each do |key, value|
      self[key].strip! if self[key].is_a?(String)
    end
  end
end
