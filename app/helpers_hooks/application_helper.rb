module ApplicationHelper
  # Returns environment variables for modules to use, as a hash:
  # :me          [get]     The current user, nil if the user has not logged in
  # :categories  [get]     All the categories
  # :category    [get]     The current category, nil if the current page (URL)
  #                        is not a category. To force the before filter to prepare
  #                        this variable, design your extension route so that
  #                        params[:category] is a box path.
  def mod
    @mod ||= {}
  end

  # Edited from Rails source code to:
  # * Remove the ugly header message and message.
  # * errorExplanation -> error.
  def error_messages_for(*params)
    options = params.extract_options!.symbolize_keys
    if object = options.delete(:object)
      objects = [object].flatten
    else
      objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
    end
    count   = objects.inject(0) {|sum, object| sum + object.errors.count }
    unless count.zero?
      html = {}
      [:id, :class].each do |key|
        if options.include?(key)
          value = options[key]
          html[key] = value unless value.blank?
        else
          html[key] = 'error'
        end
      end
      options[:object_name] ||= params.first
      error_messages = objects.sum {|object| object.errors.full_messages.map {|msg| content_tag(:li, msg) } }.join

      contents = content_tag(:ul, error_messages)
      content_tag(:div, contents, html)
    else
      ''
    end
  end
end
