class Schema < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :type,      :null => false  # Login handler class name
      t.string :user_name, :null => false  # "user_name", not just "name" because there can be first name, last name etc.
      t.string :email                      # For gravatar
      t.text   :settings
    end
  end

  def self.down
    drop_table :users
  end
end
