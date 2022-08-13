require "active_support/concern"
require "active_support/core_ext/object/json"
require "active_support/json"
require "json"
require "json_world/json_encodable"
require "json_world/link_definition"
require "json_world/property_definition"

module JsonWorld
  module DSL
    extend ActiveSupport::Concern

    included do
      include JsonWorld::JsonEncodable
    end

    private

    module ClassMethods
      attr_writer :link_definitions
      attr_writer :property_definitions

      # @return [Hash]
      def as_json_schema
        {
          '$schema': schema,
          description: description,
          links: links_as_json_schema,
          properties: properties_as_json_schema,
          required: required_property_names,
          title: title,
        }.reject do |_key, value|
          value.nil? || value.empty?
        end
      end

      # @return [Hash]
      def as_json_schema_without_links
        as_json_schema.reject do |key, _value|
          key == :links
        end
      end

      # @note Override
      def inherited(child)
        super
        child.link_definitions = link_definitions.clone
        child.property_definitions = property_definitions.clone
      end

      # @param [Symbol] link_name
      # @param [Hash{Symbol => Object}] options
      def link(link_name, options = {})
        link_definitions << JsonWorld::LinkDefinition.new(
          link_name: link_name,
          **options.merge(
            parent: self,
          ),
        )
      end

      # @return [Array<JsonWorld::LinkDefinition>]
      def link_definitions
        @link_definitions ||= []
      end

      # @param [Symbol] property_name
      # @param [Hash{Symbol => Object}] options
      def property(property_name, options = {})
        property_definitions << JsonWorld::PropertyDefinition.new(
          property_name: property_name,
          **options.merge(
            parent: self,
          )
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

      # @return [Array<Symbol>]
      def required_property_names
        property_definitions.reject(&:optional?).map(&:property_name)
      end

      # @note .as_json_schema wrapper
      # @return [String]
      def to_json_schema
        JSON.pretty_generate(as_json_schema)
      end

      private

      # @return [String, nil]
      def description(value = nil)
        @description ||= value
      end

      # @return [Array<Hash>]
      def links_as_json_schema
        link_definitions.map(&:as_json_schema)
      end

      # @return [Hash]
      def properties_as_json_schema
        property_definitions.inject({}) do |result, property_definition|
          result.merge(
            property_definition.property_name => property_definition.as_json_schema,
          )
        end
      end

      # @return [String, nil]
      def title(value = nil)
        @title ||= value
      end

      # @return [String, nil]
      def schema(value = nil)
        @schema ||= value
      end
    end
  end
end
