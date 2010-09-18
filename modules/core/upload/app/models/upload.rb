class Upload
  def self.destroy_for(model_type, model_id)
    FileUtils.rm_rf("#{Rails.root}/public/system/#{model_type.downcase}/#{model_id}")
  end
end
