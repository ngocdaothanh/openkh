class DictJaEn < ActiveRecord::Base
  set_table_name 'dict_ja_en'

  define_index do
    indexes entry, :sortable => true
    indexes pronunciation
    indexes description

    set_property :field_weights => {"entry" => 30, "pronunciation" => 20, "description" => 10}
  end
end
