class Schema < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string  :name,     :null => false, :default => 'Software and games'
      t.string  :slug,     :null => false, :default => 'software-and-games'
      t.integer :parent_id
      t.integer :position, :null => false, :default => 1
    end
    Category.create(
      :name     => Category::UNCATEGORIZED_NAME,
      :slug     => 'uncategorized',
      :position => 9999)

    create_table :categorizings do |t|
      t.integer  :category_id, :null => false
      t.string   :model_type,  :null => false
      t.integer  :model_id,    :null => false

      # = max(everything belonging to the categorizable thing)
      # :null => false is not set for Rails automation code to work
      t.datetime :model_updated_at
    end
    add_index :categorizings, :category_id
    add_index :categorizings, [:model_type, :model_id]

    # Each category has a collection of links, which may be links (table of contents)
    # to important contents of the category or external links
    create_table :links, :force => true do |t|
      t.integer :category_id  # null: for the whole site
      t.text    :body,    :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
    Link.create_versioned_table
  end

  def self.down
    Link.drop_versioned_table
    drop_table :links

    drop_table :categorizings
    drop_table :categories
  end
end
