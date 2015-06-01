module JsonWorld
  class PropertyDefinition
    # @return [Symbol]
    attr_reader :property_name

    # @param [Symbol] property_name
    # @param [Hash{Symbol => Object}] options
    def initialize(property_name: nil, **options)
      @options = options
      @property_name = property_name
    end
  end
end
