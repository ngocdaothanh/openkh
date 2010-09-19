module ApplicationHelper
  def recent_contents_block(block)
    # We must count manually
    category_ids = mod[:category].nil? ? nil : mod[:category].self_and_subnodes_at_all_depths.map { |c| c.id }
    where = category_ids.nil? ? '' : "WHERE category_id IN (#{category_ids.join(', ')})"
    count = Categorizing.count_by_sql("SELECT count(*) FROM (SELECT DISTINCT model_type, model_id FROM categorizings #{where}) AS foo")

    conditions = category_ids.nil? ? {} : {:category_id => category_ids}
    categorizings = Categorizing.paginate(
      :page          => params[:page],
      :per_page      => block.limit,
      :total_entries => count,
      :select        => 'DISTINCT model_type, model_id, model_updated_at',
      :conditions    => conditions,
      :order         => 'model_updated_at DESC')

    if categorizings.empty?
      html = ''
    else
      options = {:controller => 'contents', :action => 'recent', :block_id => block.id}
      options[:category_id] = mod[:category].id unless mod[:category].nil?
      html = render("contents/index_#{block.mode.to_s.pluralize}", :categorizings => categorizings, :options => options)
    end

    [block.title, html]
  end
end
