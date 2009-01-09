class Schema < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer  :views,        :null => false, :default => 0
      t.string   :title,        :null => false
      t.text     :introduction, :null => false
      t.text     :instruction,  :null => false
      t.integer  :user_id,      :null => false
      t.string   :ip,           :null => false, :limit => 15
      t.integer  :closed,       :null => false, :default => 0
      t.timestamps
    end

    create_table :event_joiners do |t|
      t.integer :event_id, :null => false
      t.integer :user_id,  :null => false
      t.string  :note
    end
  end

  def self.down
    drop_table :events
    drop_table :event_joiners
  end
end
