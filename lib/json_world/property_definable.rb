require "active_support/concern"
require "active_support/core_ext/object/json"
require "active_support/json"
require "json_world/json_encodable"
require "json_world/property_definition"

module JsonWorld
  module PropertyDefinable
    extend ActiveSupport::Concern

    included do
      include JsonWorld::JsonEncodable
    end

    private

    module ClassMethods
      attr_writer :property_definitions

      # @return [Hash]
      def as_json_schema
        {
          properties: properties_as_json_schema,
          required: property_names,
        }
      end

      # @note Override
      def inherited(child)
        super
        child.property_definitions = property_definitions.clone
      end

      # @todo
      def properties_as_json_schema
        property_definitions.inject({}) do |result, property_definition|
          result.merge(
            property_definition.property_name => property_definition.as_json_schema,
          )
        end
      end

      # @param [Symbol] property_name
      # @param [Hash{Symbol => ObjectA options}]
      def property(property_name, options = {})
        property_definitions << JsonWorld::PropertyDefinition.new(
          options.merge(property_name: property_name)
        )
      end

      # @return [Array<JsonWorld::PropertyDefinition>]
      def property_definitions
        @property_definitions ||= []
      end

      # @return [Array<Symbol>]
      def property_names
        property_definitions.map(&:property_name)
      end
    end
  end
end
