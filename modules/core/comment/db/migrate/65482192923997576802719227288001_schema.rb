class Schema < ActiveRecord::Migration
  def self.up
    # <model type in lower case>_id columns will be added into this table by
    # modules that acts_as_commentable
    create_table :comments do |t|
      t.integer  :user_id, :null => false
      t.text     :body,    :null => false
      t.string   :ip,      :null => false, :limit => 15
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
