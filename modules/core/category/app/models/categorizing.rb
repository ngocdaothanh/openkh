class Categorizing < ActiveRecord::Base
  belongs_to :category
  belongs_to :model, :polymorphic => true

  def self.updated_at(model_type, model_id, updated_at)
    update_all("model_updated_at = '#{updated_at}'", {:model_type => model_type, :model_id => model_id})
  end
end
