require "active_support/concern"
require "active_support/core_ext/object/json"
require "active_support/json"
require "json_world/property_definition"

module JsonWorld
  module PropertyDefinable
    extend ActiveSupport::Concern

    # @param [Hash{Symbol => Object}] options :except / :only
    # @return [Hash]
    def as_json(options = {})
      properties(options).as_json(options)
    end

    private

    # @param [Hash{Symbol => Object}] options :except / :only
    # @return [Hash]
    def properties(options = {})
      names = self.class.property_names
      names = names - Array(options[:except]) if options[:except]
      names = names & Array(options[:only]) if options[:only]
      names.inject({}) do |hash, property_name|
        key = property_name
        value = send(property_name)
        value = value.iso8601 if value.is_a?(Time)
        hash.merge(key => value)
      end
    end

    module ClassMethods
      attr_writer :property_definitions

      # @return [Hash]
      def as_json_schema
        {
          description: localized_description,
          links: links.map(&:as_json_schema),
          properties: properties_as_json_schema,
          required: required_property_names,
          title: localized_title,
        }
      end

      # @param [Symbol] property_name
      # @param [Hash{Symbol => ObjectA options}]
      def define_property(property_name, options = {})
        property_definitions << JsonWorld::PropertyDefinition.new(
          options.merge(property_name: property_name)
        )
      end

      # @note Override
      def inherited(child)
        super
        child.property_definitions = property_definitions.clone
      end

      # @return [Array<JsonWorld::PropertyDefinition>]
      def property_definitions
        @property_definitions ||= []
      end

      private

      # @return [Array<Symbol>]
      def required_property_names
        property_definitions.map(&:property_name)
      end
    end
  end
end
