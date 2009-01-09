class Schema < ActiveRecord::Migration
  def self.up
    create_table :tocs, :force => true do |t|
      t.string  :title,             :null => false
      t.text    :introduction,      :null => false
      t.text    :table_of_contents, :null => false
      t.integer :user_id,           :null => false
      t.string  :ip,                :null => false, :limit => 15
      t.timestamps
    end
    Toc.create_versioned_table

    create_table :tocs_contents, :id => false do |t|
      t.string  :content_type, :null => false
      t.integer :content_id,   :null => false
      t.integer :toc_id,       :null => false
    end
  end

  def self.down
    Toc.drop_versioned_table
    drop_table :tocs_contents
    drop_table :tocs
  end
end
