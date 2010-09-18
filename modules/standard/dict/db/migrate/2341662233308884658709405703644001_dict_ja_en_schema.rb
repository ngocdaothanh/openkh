class DictJaEnSchema < ActiveRecord::Migration
  # FIXME: download directly from the server of EDICT
  def self.import_from_edict
    file = "#{Rails.root}/tmp/edict.utf-8"

    # Download EDICT's Japanese-English dictionary to tmp
    unless File.exists?(file)
      tmp_dir = "#{Rails.root}/tmp"
      File.mkdir(tmp_dir) unless File.exists?(tmp_dir)
      system("cd #{tmp_dir} && wget http://ftp.monash.edu.au/pub/nihongo/edict.gz && gunzip edict.gz && iconv -f euc-jp -t utf-8 edict > edict.utf-8 && rm edict")
    end

    con = DictJaEn.connection

    values_array = []
    File.read(file).each_line do |l|
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
