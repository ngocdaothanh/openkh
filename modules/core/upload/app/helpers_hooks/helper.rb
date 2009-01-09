module ApplicationHelper
  # Renders list of uploaded files and lets user to upload new files.
  def html_upload_list_and_upload(object)
    html_blocklike_show(
      t('upload.uploaded_files'),
      render('uploads/list_and_upload', :object => object))
  end

  # Renders list of uploaded files.
  def html_upload_list(object)
    model_type = object.class.to_s

    down = model_type.downcase.pluralize
    model_id = object.id
    dir = File.expand_path("#{RAILS_ROOT}/public/system/#{down}/#{model_id}")
    urls = []
    if File.directory?(dir)
      files = Dir.glob("#{dir}/**/*").sort
      files.each do |f|
        next if File.directory?(f)

        name = f.split("#{dir}/").last
        url = {
          :href => "/system/#{down}/#{model_id}/#{name}",
          :stat => File::Stat.new(f)
        }

        if name =~ /(\d+?)\-(.+)/
          user = User.find_by_id($1)
          name = $2
        end

        url[:user] = user
        url[:name] = name
        urls << url
      end
    end

    render('uploads/list', :object => object, :urls => urls)
  end
end
