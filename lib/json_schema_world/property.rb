require "active_support/concern"
require "json_schema_world/property_definition"

module JsonSchemaWorld
  module Property
    extend ActiveSupport::Concern

    module ClassMethods
      # @param [Symbol] property_name
      # @param [Hash{Symbol => ObjectA options}]
      def define_property(property_name, options = {})
        properties << JsonSchemaWorld::PropertyDefinition.new(
          options.merge(property_name: property_name)
        )
      end

      # @return [Array<JsonSchemaWorld::PropertyDefinition>]
      def properties
        @properties ||= []
      end
    end
  end
end
