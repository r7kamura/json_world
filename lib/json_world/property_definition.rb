module JsonWorld
  class PropertyDefinition
    # @return [Symbol]
    attr_reader :property_name

    # @param [Symbol, nil] property_name Note that unnamed property can be passed
    # @param [Hash{Symbol => Object}] options
    def initialize(property_name: nil, **options)
      @options = options
      @property_name = property_name
    end

    # @return [Hash]
    def as_json_schema
      {
        description: description,
        example: example,
        format: format_type,
        items: items_as_json_schema,
        pattern: pattern_in_string,
        type: type_in_string,
        uniqueItems: unique_flag,
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
      if types.include?(Time)
        "date-time"
      end
    end

    # @note Tuple validation is not supported yet
    # @return [Array<Hash>, nil]
    def items_as_json_schema
      if @options[:items]
        JsonWorld::PropertyDefinition.new(@options[:items]).as_json_schema
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

    # @note type can be an Array
    # @return [Array<String>]
    def types
      Array(@options[:type])
    end

    # @return [Array<String>, String, nil]
    def type_in_string
      strings = types.map do |type|
        case
        when type == Array
          "array"
        when type == Float
          "float"
        when type == Hash
          "object"
        when type == Integer
          "integer"
        when type == NilClass
          "null"
        when type == String || type == Time
          "string"
        end
      end.compact
      strings.length >= 2 ? strings : strings.first
    end

    # @return [false, nil, true]
    def unique_flag
      if @options.key?(:unique)
        !!@options[:unique]
      end
    end
  end
end
