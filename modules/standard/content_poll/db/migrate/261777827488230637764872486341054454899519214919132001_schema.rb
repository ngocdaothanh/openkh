class Schema < ActiveRecord::Migration
  def self.up
    create_table :polls do |t|
      t.integer  :views,     :null => false, :default => 0
      t.string   :title,     :null => false
      t.text     :responses, :null => false  # Serialized array of responses
      t.text     :votes,     :null => false  # Serialized array of number of votes for each response
      t.text     :voters,    :null => false  # Serialized array of ids of voters
      t.integer  :user_id,   :null => false
      t.timestamps
    end
    add_column :comments, :poll_id, :integer
  end

  def self.down
    remove_column :comments, :poll_id
    drop_table :polls
  end
end
