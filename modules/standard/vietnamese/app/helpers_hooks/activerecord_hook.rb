# -*- coding: utf-8 -*-

ActiveRecord::Base.class_eval do
  def sanitize_to_param_with_vietnamese(to_param_result)
    ret = to_param_result
    ret = ret.gsub(/[àáạảãâầấậẩẫăằắặẳẵÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴ]/, 'a')
    ret = ret.gsub(/[ìíịỉĩÌÍỊỈĨ]/, 'i')
    ret = ret.gsub(/[ùúụủũưừứựửữÙÚỤỦŨƯỪỨỰỬỮ]/, 'u')
    ret = ret.gsub(/[èéẹẻẽêềếệểễÈÉẸẺẼÊỀẾỆỂỄ]/, 'e')
    ret = ret.gsub(/[òóọỏõôồốộổỗơờớợởỡÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ]/, 'o')
    ret = ret.gsub(/[ỳýỵỷỹỲÝỴỶỸ]/, 'y')
    ret = ret.gsub(/[đĐ]/, 'd')
    ret = sanitize_to_param_without_vietnamese(ret)
    return ret
  end
  alias_method_chain :sanitize_to_param, :vietnamese
end
