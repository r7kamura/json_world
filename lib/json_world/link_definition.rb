module JsonWorld
  class LinkDefinition
    # @return [Symbol]
    attr_reader :link_name, :options

    # @param [Symbol] link_name
    # @param [Hash{Symbol => Object}] options
    def initialize(link_name: nil, **options)
      @options = options
      @link_name = link_name
    end

    # @todo
    # @return [Hash]
    def as_json_schema
      {
        href: path,
        title: title,
      }
    end

    private

    # @return [String]
    def path
      options[:path]
    end

    # @return [String]
    def title
      options[:title] || @link_name.to_s
    end
  end
end
