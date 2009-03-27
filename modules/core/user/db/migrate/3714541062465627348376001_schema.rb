class Schema < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :type,      :null => false  # Login handler class name
      t.string :user_name, :null => false
      t.string :email                      # For gravatar
      t.text   :settings
    end

    # Log IP of users on every login
    create_table :ips do |t|
      t.integer  :user_id,    :null => false
      t.string   :ip,         :null => false, :limit => 15
      t.datetime :created_at, :null => false
    end
  end

  def self.down
    drop_table :ips
    drop_table :users
  end
end
