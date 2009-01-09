class Schema < ActiveRecord::Migration
  def self.up
    create_table :confs do |t|
      t.string :type, :null => false
      t.text   :settings
    end
  end

  def self.down
    drop_table :confs
  end
end
