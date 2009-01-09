module ApplicationHelper
  def recent_contents_block(block)
    # We must count manually
    types = block.types.map { |t| Categorizing.connection.quote(t)}
    category_ids = mod[:category].nil? ? nil : mod[:category].self_and_subnodes_at_all_depths.map { |c| c.id }
    where = "model_type IN (#{types.join(', ')})"
    where += " AND category_id IN (#{category_ids.join(', ')})" unless category_ids.nil?
    count = Categorizing.count_by_sql("SELECT count(*) FROM (SELECT DISTINCT model_type, model_id FROM categorizings WHERE #{where}) AS foo")

    conditions = {:model_type => block.types}
    conditions[:category_id] = category_ids unless category_ids.nil?
    categorizings = Categorizing.find(
      :all,
      :page       => {:current => params[:page], :size => block.limit, :count => count},
      :select     => 'DISTINCT model_type, model_id, model_updated_at',
      :conditions => conditions,
      :order      => 'model_updated_at DESC')
    contents = PagingEnumerator.new(categorizings.page_size, categorizings.size, categorizings.auto, categorizings.page, categorizings.first_page) do |page|
      categorizings.map { |c| c.model }
    end

    if contents.empty?
      content = ''
    else
      options = {:controller => 'contents', :action => 'recent', :block_id => block.id}
      options[:category_id] = mod[:category].id unless mod[:category].nil?
      content = render("contents/index_#{block.mode.to_s.pluralize}", :contents => contents, :options => options)
    end

    [block.title, content]
  end
end
