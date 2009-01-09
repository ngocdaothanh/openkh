module ActsAsConfigurable
  # Avoid xxx_before_type_cast error (xxx are the virtual attributes).
  # http://d.hatena.ne.jp/moro/20060419/1145461336
  def method_missing(method, *args)
    if method.to_s =~ /(\w+)_before_type_cast/
      before_type_cast($1.to_sym)
    else
      super
    end
  end

  private

  def before_type_cast(attr_name)
    self.__send__(attr_name)
  end
end
