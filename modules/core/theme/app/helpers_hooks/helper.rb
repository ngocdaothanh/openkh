module ApplicationHelper
  def theme_prepare
    mod[:head] = render('layouts/head')

    regions = {}  # Hash of arrays of [title, content]
    CONF[:regions].each_with_index do |r, i|
      next if r == :content && !(block_index? || site_root_or_categories_show?)

      blocks = Block.in_region(i)
      regions[r] = blocks.map do |b|
        if block_index?
          underscored_class_name = b.class.to_s.underscore
          title   = t("#{underscored_class_name}.title")
          content = render('admin_blocks/conf', :block => b)
          ret = [title, content]
        else
          helper_name = b.class.to_s.underscore
          ret = send(helper_name, b)
        end

        ret[1].blank? ? nil : ret  # Do not render if content is blank
      end
      regions[r].compact!          # Do not render if content is blank
    end

    mod[:regions] = {}  # Hash of HTML for regions
    CONF[:regions].each do |r|
      mod[:regions][r] = regions[r].nil? ?
        '' :
        render('layouts/region', :region => r, :blocks => regions[r])
    end

    if block_index?
      CONF[:regions].each do |r|
        desc = r.to_s
        if r == :content
          desc << ': ' << t('theme.notice_for_content_region')
          #mod[:regions][r] << '<hr style="clear:both" />'
        end
        mod[:regions][r] = content_tag(:p, desc, :class => 'notice') + mod[:regions][r]
      end
    end
  end

  def site_root_or_categories_show?
    @site_or_categories_show ||= ((params[:controller] == 'site' && params[:action] == 'root') || (params[:controller] == 'categories' && params[:action] == 'show'))
  end

  def block_index?
    @block_index ||= (params[:controller] == 'admin_blocks' && params[:action] == 'index')
  end

  #-----------------------------------------------------------------------------

  # Renders a block from name and content.
  def html_block_show(block)
    title, content = send(block.class.to_s.underscore, block)
    html_blocklike_show(title, content)
  end

  # Renders a blocklike block of HTML from title and content.
  # This method can be used from anywhere to display a block of HTML content with a title.
  def html_blocklike_show(title, content)
    render('layouts/block', :title   => title, :content => content) unless content.blank?
  end

  #-----------------------------------------------------------------------------

  def region_select_choices
    ret = [['---', -1]]
    CONF[:regions].each_with_index { |r, i| ret << [r, i] }
    ret
  end

  def theme_image_tag(file_name, options = {})
    image_tag("../themes/#{CONF[:theme]}/images/#{file_name}", options)
  end
end
