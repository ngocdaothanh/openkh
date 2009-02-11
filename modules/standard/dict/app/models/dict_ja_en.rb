class DictJaEn < ActiveRecord::Base
  set_table_name 'dict_ja_en'

  define_index do
    indexes entry, :sortable => true
    indexes pronunciation, :sortable => true
    indexes description

    has 'LENGTH(entry)', :type => :integer, :as => :entry_size  # Shorter is better

    set_property :field_weights => {"entry" => 3, "pronunciation" => 2, "description" => 1}
  end

  def self.search_for_keyword(keyword, options = {})
    options.update({:order => 'entry_size asc, pronunciation asc, entry asc'})
    search(keyword, options)
  end
end
