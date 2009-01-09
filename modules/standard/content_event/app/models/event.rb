class Event < ActiveRecord::Base
  acts_as_content

  has_many :event_joiners, :dependent => :destroy
  has_many :users, :through => :event_joiners

  validates_presence_of :introduction, :instruction

  def join(user, note)
    EventJoiner.destroy_all(:event_id => id, :user_id => user.id)
    EventJoiner.create(:event_id => id, :user_id => user.id, :note => note)
  end

  def unjoin(user)
    EventJoiner.destroy_all(:event_id => id, :user_id => user.id)
  end
end
