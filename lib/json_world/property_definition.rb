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

    # @todo
    # @return [Hash]
    def as_json_schema
      {
        description: description,
        example: example,
        format: format_type,
        pattern: pattern_in_string,
        type: type_in_string,
      }.reject do |_key, value|
        value.nil? || value.respond_to?(:empty?) && value.empty?
      end
    end

    private

    # @return [String, nil]
    def description
      @options[:description]
    end

    # @return [Object]
    def example
      @options[:example]
    end

    # @note format is preserved by Kernel.#format ;(
    # @return [String, nil]
    def format_type
      if type == Time
        "date-time"
      end
    end

    # @note pattern can be used only when type is String or not specified
    # @return [Regexp, nil]
    def pattern
      @options[:pattern]
    end

    # @return [String, nil]
    def pattern_in_string
      if pattern
        pattern.inspect[1..-2]
      end
    end

    # @return [String, nil]
    def type
      @options[:type]
    end

    # @return [String, nil]
    def type_in_string
      case
      when type == Array
        "array"
      when type == Float
        "float"
      when type == Hash
        "object"
      when type == Integer
        "integer"
      when type == String || type == Time
        "string"
      end
    end
  end
end
