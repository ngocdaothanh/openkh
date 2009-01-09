class Schema < ActiveRecord::Migration
  def self.up
    create_table :google_map_markers do |t|
      t.integer :google_map_block_id, :null => false
      t.string  :title,               :null => false
      t.float   :latitude,            :null => false
      t.float   :longitude,           :null => false
      t.text    :html
    end
  end

  def self.down
    drop_table :google_map_markers
  end
end
