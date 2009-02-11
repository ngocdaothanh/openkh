class DictJaEnSchema < ActiveRecord::Migration
  # FIXME: download directly from the server of EDICT
  def self.import_from_edict
    source = File.read('/Users/ngocdt/tmp/edict.utf8')

    con = DictJaEn.connection

    values_array = []
    source.each_line do |l|
      next unless l =~ /^(.+)\s\[(.+)\]\s\/(.+)\/$/

      entry, pronunciation, description = con.quote($1), con.quote($2), con.quote($3)
      values_array << "(#{entry}, #{pronunciation}, #{description})"
    end

    values_string = values_array.join(', ')
    sql = "INSERT INTO dict_ja_en(entry, pronunciation, description) VALUES #{values_string}"
    con.execute(sql)
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
