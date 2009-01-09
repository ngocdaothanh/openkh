class Bliki < ActiveRecord::Base
  acts_as_versioned
  self.non_versioned_columns << 'open' << 'views' << 'updated_at'

  acts_as_content

  validates_presence_of :introduction, :body

  # Converts to QA, returns true on success or false on failure.
  def to_qa
    Bliki.transaction do
      Qa.record_timestamps = false
      qa = Qa.create(
        :updated_at => self.updated_at,
        :views      => self.views,
        :title      => self.title,
        :message    => "#{self.abstract}#{self.details}",
        :tags       => self.tags,
        :user_id    => self.versions.first.user_id,
        :ip         => self.ip,
        :created_at => self.versions.first.created_at,
        :boxes      => self.boxes)  # Convert mountpoints
      Qa.record_timestamps = true

      # Convert comments
      con = ActiveRecord::Base.connection
      con.update("update comments set model_type = 'Qa', " +
        "model_id = #{qa.id} where model_type = 'Bliki' and " +
        "model_id = #{self.id}")

      # Convert upload directory
      FileUtils.mv("#{RAILS_ROOT}/public/system/blikis/#{id}",
        "#{RAILS_ROOT}/public/system/qas/#{qa.id}", :force => true)

      # See after_destroy
      destroy
    end
    true
  rescue
    false
  end
end
