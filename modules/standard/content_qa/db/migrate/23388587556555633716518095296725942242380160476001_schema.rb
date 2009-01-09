class Schema < ActiveRecord::Migration
  def self.up
    create_table :qas do |t|
      t.integer :views, :null => false, :default => 0
      t.string  :title,      :null => false
      t.integer :user_id,    :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :qas
  end
end
