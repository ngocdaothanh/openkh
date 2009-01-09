ActionController::Base.class_eval do
  private

  # Used by AdminController.
  class_inheritable_accessor :breadcrumbs

  def self.add_breadcrumb(title, path = '', options = {})
    self.breadcrumbs ||= []
    self.breadcrumbs << [title, path]

    before_filter(options) do |controller|
      controller.send(:add_breadcrumb, title, path)
    end
  end

  def add_breadcrumb(title, path = '')
    path = eval(path) if path =~ /_path|_url|@/
    @breadcrumbs ||= []
    @breadcrumbs << [title, path]
  end
end
