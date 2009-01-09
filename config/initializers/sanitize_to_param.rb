# SEO, more at http://www.seoonrails.com
ActiveRecord::Base.class_eval do
  def sanitize_to_param(to_param_result)
    ret = to_param_result.downcase
    ret = ret.gsub(/ /, '-')             # Replace space with hyphen
    ret = ret.gsub(/[^[:alnum:]-]/, '')  # Remove non alphanumeric characters
    ret = ret.gsub(/-{2,}/, '-')         # Replace 2 or more hyphens with one
    ret = ret.gsub(/-+$/, '')            # Remove hyphen at the end
    ret
  end
end
