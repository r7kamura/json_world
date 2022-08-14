require "active_support/core_ext/object/try"

module JsonWorld
  class PropertyDefinition
    # @return [Symbol]
    attr_reader :property_name

    # @param [Symbol, nil] property_name Note that unnamed property can be passed
    # @param [Hash{Symbol => Object}] options
    def initialize(property_name: nil, options)
      @options = options
      @property_name = property_name
    end

    # @return [Hash{Symbol => Object}]
    def as_json_schema
      if has_json_schema_compatible_type?
        if @options[:links]
          @options[:type].as_json_schema
        else
          @options[:type].as_json_schema_without_links
        end
      else
        {
          description: description,
          example: example,
          format: format_type,
          items: items_as_json_schema,
          pattern: pattern_in_string,
          properties: properties_as_json_schema,
          required: required_property_names,
          type: type,
          uniqueItems: unique_flag,
        }.reject do |_key, value|
          value.nil? || value.respond_to?(:empty?) && value.empty?
        end
      end
    end

    # @return [Hash{Symbol => Object}]
    def as_nested_json_schema
      { property_name => as_json_schema }
    end

    # @return [false, true] True if explicitly this property is defined as optional
    def optional?
      !!@options[:optional]
    end

    # @return [Hash{Symbol => Object}]
    def raw_options
      @options.merge(
        property_name: @property_name,
      )
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

    # @return [false, true]
    def has_json_schema_compatible_type?
      @options[:type].respond_to?(:as_json_schema)
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

    # @return [Hash, nil]
    def properties_as_json_schema
      if @options[:properties]
        property_definitions.map(&:as_nested_json_schema).inject({}, :merge)
      end
    end

    # @return [Array, nil]
    def property_definitions
      if @options[:properties]
        @options[:properties].map do |property_name, options|
          JsonWorld::PropertyDefinition.new(
            property_name: property_name,
            options
          )
        end
      end
    end

    # @return [Array<Symbol>, nil]
    def required_property_names
      if @options[:properties]
        property_definitions.reject(&:optional?).map(&:property_name)
      end
    end

    # @return [Array<String>, String, nil]
    def type
      strings = types.map do |this_type|
        case
        when this_type == Array
          "array"
        when this_type == FalseClass || this_type == TrueClass
          "boolean"
        when this_type == Float
          "float"
        when this_type == Hash
          "object"
        when this_type == Integer
          "integer"
        when this_type == NilClass
          "null"
        when this_type == String || this_type == Time
          "string"
        when this_type.is_a?(String)
          this_type
        end
      end.compact.uniq
      strings.length >= 2 ? strings : strings.first
    end

    # @note type can be an Array
    # @return [Array<String>]
    def types
      Array(@options[:type])
    end

    # @return [false, nil, true]
    def unique_flag
      if @options.key?(:unique)
        !!@options[:unique]
      end
    end
  end
end
