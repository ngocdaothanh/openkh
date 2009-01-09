class UploadConf < Conf
  acts_as_configurable do |c|
    c.integer :limit, :default => 10  # MB
  end

  validates_numericality_of :limit, :only_integer => true
end
