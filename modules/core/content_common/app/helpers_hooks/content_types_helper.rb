module ApplicationHelper
  def content_types_block(block)
    content = content_tag(:li, link_to(t('common.create') + ' ' + image_tag('edit.png'), new_content_path))
    ActiveRecord::Acts::Content.model_types.each do |t|
      klass = t.constantize
      down = t.downcase
      plural = down.pluralize
      name = t("#{klass.to_s.underscore}.name")
      name_count = "#{name} (#{klass.count})"
      content << content_tag(:li, link_to(name_count, send("#{plural}_path")))
    end
    content = content_tag(:ul, content)

    [t('content.content_types'), content]
  end
end
