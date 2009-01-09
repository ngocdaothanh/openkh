class Schema < ActiveRecord::Migration
  def self.up
    create_table :blocks do |t|
      t.string  :type,     :null => false
      t.integer :region,   :null => false, :default => -1  # Index in region array, negative to mark that the block does not belong to any region
      t.integer :position, :null => false, :default => 1
      t.text    :settings
    end

    create_table :blocks_categories, :id => false do |t|
      t.integer :block_id,    :null => false
      t.integer :category_id, :null => false
    end
  end

  def self.down
    drop_table :blocks
    drop_table :blocks_categories
  end
end
