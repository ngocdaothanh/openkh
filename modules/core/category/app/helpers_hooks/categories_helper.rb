module ApplicationHelper
  def categories_block(block)
    content = ''
    mod[:categories] << Category.uncategorized
    mod[:categories].each do |cat|
      content << html_tree(cat) do |c, level|
        link = link_to(c.name, category_path(:slug => c.slug))
        [(c == mod[:category])? content_tag(:em, link) : link ]
      end
    end
    content = content_tag(:ul, content, :class => 'tree pages')
    [t('category.categories'), content]
  end

  def toc_block(block)
    category = Category.find(block.category_id)
    [t('toc_block.title'), render('toc_block/show', :category => category)]
  end
end
