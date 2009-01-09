class Schema < ActiveRecord::Migration
  def self.up
    create_table :polls do |t|
      t.string   :title,     :null => false
      t.text     :responses, :null => false  # Serialized array of responses
      t.text     :votes,     :null => false  # Serialized array of number of votes for each response
      t.text     :voters,    :null => false  # Serialized array of ids of voters
      t.integer  :user_id,   :null => false
      t.string   :ip,        :null => false, :limit => 15
      t.timestamps
    end
  end

  def self.down
    drop_table :polls
  end
end
