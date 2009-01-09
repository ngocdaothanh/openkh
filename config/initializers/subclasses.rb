# Make method "subclasses" of ActiveRecord::Base public for easier STI use.
ActiveRecord::Base.class_eval do
  class << self
    public :subclasses
  end
end
