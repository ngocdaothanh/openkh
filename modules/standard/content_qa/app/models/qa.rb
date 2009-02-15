class Qa < ActiveRecord::Base
  attr_accessor :message, :ip

  acts_as_content

  validates_presence_of :message, :on => :create

  #-----------------------------------------------------------------------------

  define_index do
    indexes title
    #indexes comments.message, :as => :comments

    #set_property :field_weights => {'title' => 10, 'comments' => 1}

    has updated_at
  end

  def self.search_for_keyword(keyword, options = {})
    options.update({:order => 'updated_at DESC'})
    search(keyword, options)
  end

  #-----------------------------------------------------------------------------

  def after_create
    Comment.record_timestamps = false
    Comment.create(
      :model_type => 'Qa',
      :model_id   => self.id,
      :message    => self.message,
      :user_id    => self.user_id,
      :ip         => self.ip,
      :created_at => self.created_at,
      :updated_at => self.updated_at)
    Comment.record_timestamps = true
  end
end
