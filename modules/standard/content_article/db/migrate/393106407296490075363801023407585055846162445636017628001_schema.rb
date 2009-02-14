class Schema < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      # Non-versioned
      t.integer  :views, :null => false, :default => 0
      t.datetime :updated_at

      # Versioned
      t.string   :title,        :null => false
      t.text     :introduction, :null => false
      t.text     :body,         :null => false
      t.integer  :user_id,      :null => false
      t.string   :ip,           :null => false, :limit => 15
      t.datetime :created_at,   :null => false  # The time of creation of a version, the program must manually modify this
    end
    Article.create_versioned_table
  end

  def self.down
    Article.drop_versioned_table
    drop_table :articles
  end
end
