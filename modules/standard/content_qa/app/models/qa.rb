class Qa < ActiveRecord::Base
  attr_accessor :body

  acts_as_content

  validates_presence_of :body, :on => :create

  define_index do
    indexes title
    indexes comments.body, :as => :comments

    set_property :field_weights => {'title' => 10, 'comments' => 1}

    has updated_at
  end

  def after_create
    Comment.record_timestamps = false
    Comment.create(
      :model_type => 'Qa',
      :model_id   => self.id,
      :body       => self.body,
      :user_id    => self.user_id,
      :created_at => self.created_at,
      :updated_at => self.updated_at)
    Comment.record_timestamps = true
  end
end
