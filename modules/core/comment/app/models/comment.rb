class Comment < ActiveRecord::Base
  attr_reader :model_type, :model_id

  belongs_to :user

  validates_presence_of :model_type, :model_id, :message

  #-----------------------------------------------------------------------------

  def self.key(model_type_or_class_or_object)
    if model_type_or_class_or_object.is_a?(String)
      s = model_type_or_class_or_object
    elsif model_type_or_class_or_object.is_a?(Class)
      s = model_type_or_class_or_object.to_s
    else
      s = model_type_or_class_or_object.class.to_s
    end

    down = s.downcase
    "#{down}_id".intern
  end

  def model_type=(value)
    @model_type = value
    send("#{Comment.key(@model_type)}=", @model_id) unless @model_id.nil?
    value
  end

  def model_id=(value)
    @model_id = value
    send("#{Comment.key(@model_type)}=", @model_id) unless @model_type.nil?
    value
  end

  #-----------------------------------------------------------------------------

  def self.destroy_for(model_type, model_id)
    Comment.delete_all({key(model_type) => model_id})
  end

  def self.first(model_type, model_id)
    Comment.find(
      :first,
      :conditions => {key(model_type) => model_id},
      :order => 'created_at ASC')
  end

  def self.last(object)
    Comment.find(
      :first,
      :conditions => {key(object) => object.id},
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
