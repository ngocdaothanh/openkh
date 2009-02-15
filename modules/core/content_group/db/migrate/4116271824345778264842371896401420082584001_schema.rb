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

    create_table :contents_groups, :id => false do |t|
      t.string  :content_type, :null => false
      t.integer :content_id,   :null => false
      t.integer :group_id,     :null => false
    end

    add_column :comments, :group_id, :integer
  end

  def self.down
    remove_column :comments, :group_id
    drop_table :contents_groups
    Group.drop_versioned_table
    drop_table :groups
  end
end
