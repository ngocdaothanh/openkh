class Schema < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name
    end

    create_table :taggings do |t|
      t.integer :tag_id
      t.integer :taggable_id
      t.string  :taggable_type
    end
    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type]
  end

  def self.down
    drop_table :taggings
    drop_table :tags
  end
end
