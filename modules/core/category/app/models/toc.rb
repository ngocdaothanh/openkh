class Toc < ActiveRecord::Base
  acts_as_versioned
  self.non_versioned_columns << 'updated_at'

  validates_presence_of :table_of_contents
end
