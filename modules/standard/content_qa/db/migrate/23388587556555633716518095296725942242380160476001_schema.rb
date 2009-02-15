class Schema < ActiveRecord::Migration
  def self.up
    create_table :qas do |t|
      t.integer :views, :null => false, :default => 0
      t.string  :title,      :null => false
      t.integer :user_id,    :null => false
      t.timestamps
    end
    add_column :comments, :qa_id, :integer
  end

  def self.down
    remove_column :comments, :qa_id
    drop_table :qas
  end
end
