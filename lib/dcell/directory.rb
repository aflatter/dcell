module DCell
  # Directory of nodes connected to the DCell cluster
  #
  # WARNING: This is an internal API and kept for backwards-compatibility.
  #          It may be removed at some point.
  module Directory
    extend self

    # Get the URL for a particular Node ID
    def get(node_id)
      DCell.registry.get(:nodes, node_id)
    end
    alias_method :[], :get

    # Set the address of a particular Node ID
    def set(node_id, addr)
      DCell.registry.set(:nodes, node_id, addr)
    end
    alias_method :[]=, :set

    # List all of the node IDs in the directory
    def all
      DCell.registry.keys(:nodes)
    end
  end
end
