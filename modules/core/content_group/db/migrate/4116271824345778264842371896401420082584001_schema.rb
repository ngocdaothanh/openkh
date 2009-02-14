class Schema < ActiveRecord::Migration
  def self.up
    create_table :groups, :force => true do |t|
      t.string  :title,        :null => false
      t.text    :introduction, :null => false
      t.text    :links,        :null => false
      t.integer :user_id,      :null => false
      t.string  :ip,           :null => false, :limit => 15
      t.timestamps
    end
    Group.create_versioned_table

    create_table :groups_contents, :id => false do |t|
      t.string  :content_type, :null => false
      t.integer :content_id,   :null => false
      t.integer :group_id,     :null => false
    end
  end

  def self.down
    Group.drop_versioned_table
    drop_table :groups_contents
    drop_table :groups
  end
end
