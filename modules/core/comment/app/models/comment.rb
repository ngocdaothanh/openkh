class Comment < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :model_type, :model_id, :message

  def self.destroy_for(model_type, model_id)
    Comment.delete_all({:model_type => model_type, :model_id => model_id})
  end

  def self.first(model_type, model_id)
    Comment.find(
      :first,
      :conditions => {:model_type => model_type, :model_id => model_id},
      :order => 'created_at ASC')
  end

  def self.last(object)
    Comment.find(
      :first,
      :conditions => {:model_type => object.class.to_s, :model_id => object.id},
      :order => 'created_at DESC')
  end

  def validate
    if !ActiveRecord::Acts::Commentable.model_types.include?(model_type)
      errors.add_to_base(t('common.hack_you'))
    else
      klass = model_type.constantize
      errors.add_to_base(t('comment.model_deleted')) unless klass.exists?(model_id)
    end
  end

  def after_save
    Categorizing.updated_at(model_type, model_id, updated_at)
  end
end
