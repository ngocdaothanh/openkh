module ApplicationHelper
  def content_types_block(block)
    content = content_tag(:li, link_to(t('common.create') + ' ' + theme_image_tag('edit.png'), new_content_path))
    ActiveRecord::Acts::Content.model_types.each do |t|
      klass = t.constantize
      down = t.downcase
      plural = down.pluralize
      name = t("#{klass.to_s.underscore}.name")
      content << content_tag(:li, link_to(name, send("#{plural}_path")) + " (#{klass.count})")
    end
    content = content_tag(:ul, content)

    [t('content.content_types'), content]
  end
end
