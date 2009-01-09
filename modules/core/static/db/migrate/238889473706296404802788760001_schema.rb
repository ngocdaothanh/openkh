class Schema < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string  :title,    :null => false, :default => 'Software and games'
      t.string  :slug,     :null => false, :default => 'software-and-games'
      t.text    :body,     :null => false
      t.integer :parent_id
      t.integer :position, :null => false, :default => 1
    end
  end

  def self.down
    drop_table :pages
  end
end
