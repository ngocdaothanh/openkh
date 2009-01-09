class Schema < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string   :model_type, :null => false
      t.integer  :model_id,   :null => false
      t.integer  :user_id,    :null => false
      t.text     :message,    :null => false
      t.string   :ip,         :null => false, :limit => 15
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
