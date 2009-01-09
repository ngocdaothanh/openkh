class Upload
  def self.destroy_for(model_type, model_id)
    FileUtils.rm_rf("#{RAILS_ROOT}/public/system/#{model_type.downcase}/#{model_id}")
  end
end
