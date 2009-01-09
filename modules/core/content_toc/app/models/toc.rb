class Toc < ActiveRecord::Base
  acts_as_versioned
  self.non_versioned_columns << 'updated_at'

  acts_as_content

  validates_presence_of :introduction, :table_of_contents

  # Update tocs_contents table.
  def after_save
    contents = contents_from_html
    con = ActiveRecord::Base.connection
    con.transaction do
      con.execute("DELETE FROM tocs_contents WHERE toc_id=#{self.id}")
      contents.each do |n|
        content_type = con.quote(n.class.to_s)
        con.execute("INSERT INTO tocs_contents(content_type, content_id, toc_id) VALUES(#{content_type}, #{n.id}, #{self.id})")
      end
    end
  end

  def contents_from_html
    types_ids = []
    html = introduction + table_of_contents
    page = Hpricot(html)
    links = page.search('//a')
    links.each do |l|
      href = l.attributes['href']
      ActiveRecord::Acts::Content.model_types.each do |t|
        underscore = t.underscore
        if href =~ /\/#{underscore.pluralize}\/(.+)/  # The URL must be in the form /plural/id
          id = $1.to_i
          types_ids << [t, id]
        end
      end
    end

    ret = []
    types_ids.uniq!
    types_ids.each do |t, id|
      klass = t.constantize
      content = klass.find_by_id(id)
      ret << content unless content.nil?
    end
    ret
  end
end
