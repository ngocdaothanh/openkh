class DictJaEnSchema < ActiveRecord::Migration
  # FIXME: download directly from the server of EDICT
  def self.import_from_edict
    source = File.read('/Users/ngocdt/tmp/edict.utf8')
    source.each_line do |l|
      next unless l =~ /^(.+)\s\[(.+)\]\s\/(.+)\/$/
      DictJaEn.create :entry => $1, :pronunciation => $2, :description => $3
    end
  end

  def self.up
    create_table :dict_ja_en do |t|
      t.string :entry
      t.string :pronunciation
      t.text   :description
    end

    import_from_edict
  end

  def self.down
    drop_table :dict_ja_en
  end
end
