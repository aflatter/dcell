class DCell::Registry::Base
  include Celluloid

  def get(namespace, key)
    abort NotImplementedError.new
  end
  alias_method :[], :get

  def set(namespace, key, value)
    abort NotImplementedError.new
  end
  alias_method :[]=, :set

  def delete(namespace, key)
    abort NotImplementedError.new
  end

  def keys(namespace)
    abort NotImplementedError.new
  end

  def clear(namespace)
    abort NotImplementedError.new
  end
end
