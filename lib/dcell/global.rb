module DCell
  # Global object registry shared among all DCell nodes
  module Global
    extend self

    # Get a global value
    def get(key)
      DCell.registry.get(:global, key)
    end
    alias_method :[], :get

    # Set a global value
    def set(key, value)
      DCell.registry.set(:global, key, value)
    end
    alias_method :[]=, :set

    # Get the keys for all the globals in the system
    def keys
      DCell.registry.keys(:global).map(&:to_sym)
    end
  end
end
