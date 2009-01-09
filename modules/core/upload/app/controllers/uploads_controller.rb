class UploadsController < ApplicationController
  before_filter :check_login,   :only => [:create, :destroy]
  before_filter :check_captcha, :only => [:create]

  def create
    failed = false
    notice = t('upload.success')
    begin
      # Check login
      if mod[:me].nil?
        notice = t('upload.login_to_upload')
        raise
      end

      # Check file
      file = params[:uploaded_file]
      if file.nil? or file.size == 0
        notice = t('upload.provide_file')
        raise
      end
      if file.size > CONF[:upload_size_limit]
        notice = t('upload.too_big')
        raise
      end
      file_name = sanitize(file.original_filename)

      model_type = params[:model_type]
      model_id = params[:model_id]
      if !ActiveRecord::Acts::Uploadable.model_types.include?(model_type) or model_id !~ /^\d+$/
        notice = t('common.hack_you')
        raise
      end
      dir_name = "#{RAILS_ROOT}/public/system/#{model_type.downcase.pluralize}/#{model_id}"
      FileUtils.mkdir_p(dir_name, :mode => 0755)

      full_name = "#{dir_name}/#{mod[:me].id}-#{file_name}"
      if File.exist?(full_name)
        notice = t('upload.same_file_exists')
        raise
      end

      # The file can be a String, StringIO or TempFile
      File.open(full_name, 'wb') { |f| f.write(file.read) }

      update_at(model_type, model_id)
    rescue
      failed = true
    end

    responds_to_parent do
      render(:update) do |page|
        page.replace_html('uploads_list', _uploads_list(model_type, model_id)) unless failed
        page << 'uploadsToggle();'
        page.alert(notice)
      end
    end
  end

  def destroy
    failed = false
    notice = t('upload.deleted')
    begin
      # Check file
      name = params[:href].gsub(/http:\/\/.*?\//, '')  # Remove http://xxx prefix if any
      if name =~ /\.\./
        notice = t('common.hack_you')
        raise
      end

      # Check user
      if (name =~ /(\d+?)\-/).nil?
        # Only admin can delete file without user id
        unless users_admin?
          notice = t('common.hack_you')
          raise
        end
      else
        user_id = $1.to_i
        if mod[:me].id != user_id and !users_admin?
          notice = t('upload_delete_own_file')
          raise
        end
      end

      full_name = "#{RAILS_ROOT}/public/#{name}"
      FileUtils.rm_rf(full_name)

      # Try purging empty directory
      begin
        dir = File.dirname(full_name)
        Dir.delete(dir)  # Only delete if the directory is empty
      rescue
      end

      # Refresh file list
      model_type = params[:model_type]
      model_id = params[:model_id]
      if !ActiveRecord::Acts::Uploadable.model_types.include?(model_type) or model_id !~ /^\d+$/
        notice = t('common.hack_you')
        raise
      end
      update_at(model_type, model_id)
    rescue
      failed = true
    end

    render(:update) do |page|
      page.replace_html('uploads_list', _uploads_list(model_type, model_id)) unless failed
      page.alert(notice)
    end
  end

private

  def sanitize(path)
    if RUBY_PLATFORM =~ %r{unix|linux|solaris|freebsd}
      # Not required for unix platforms since all characters
      # are allowed (except for /, which is stripped out below)
    elsif RUBY_PLATFORM =~ %r{win32}
      # Replace illegal characters for NTFS with _
      path.gsub!(/[\x00-\x1f\/|?*]/, '_')
    else
      # Assume a very restrictive OS such as MSDOS
      path.gsub!(/[\/|\?*+\]\[ \x00-\x1fa-z]/, '_')
    end

    # For files uploaded by Windows users, strip off the beginning path
    return path.gsub(/^.*[\\\/]/, '')
  end

  def update_at(model_type, model_id)
    model_class = eval(model_type)
    model = model_class.find_by_id(model_id)
    model.updated_at = Time.now
    begin
      model.save_without_revision
    rescue
      model.save
    end
  end
end
