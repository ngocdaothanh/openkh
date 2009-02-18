class Group < ActiveRecord::Base
  acts_as_versioned
  self.non_versioned_columns << 'updated_at'

  acts_as_content

  validates_presence_of :introduction, :links

  define_index do
    indexes title
    indexes introduction
    indexes comments.body, :as => :comments

    set_property :field_weights => {'title' => 10, 'introduction' => 5, 'comments' => 1}

    has updated_at
  end

  # Update groups_contents table.
  def after_save
    contents = contents_from_html
    con = ActiveRecord::Base.connection
    con.transaction do
      con.execute("DELETE FROM contents_groups WHERE group_id=#{self.id}")
      contents.each do |n|
        content_type = con.quote(n.class.to_s)
        con.execute("INSERT INTO contents_groups(content_type, content_id, group_id) VALUES(#{content_type}, #{n.id}, #{self.id})")
      end
    end
  end

  # Returns an array of content objects.
  def contents_from_html
    types_ids = []
    html = introduction + links
    page = Hpricot(html)
    as = page.search('//a')
    as.each do |a|
      href = a.attributes['href']
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
