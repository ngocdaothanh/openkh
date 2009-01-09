class ChatBlock < Block
  acts_as_configurable do |c|
    c.integer :remote_port, :default => 443
  end

  validates_presence_of :remote_port
  validates_numericality_of :remote_port
end
