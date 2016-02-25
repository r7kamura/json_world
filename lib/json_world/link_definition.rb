module JsonWorld
  class LinkDefinition
    DEFAULT_HTTP_METHOD = "GET"

    # @return [Symbol]
    attr_reader :link_name

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
        description: description,
        href: path,
        mediaType: media_type,
        method: http_method,
        rel: rel,
        schema: schema,
        targetSchema: target_schema,
        title: title,
      }.reject do |_key, value|
        value.nil? || value.empty?
      end
    end

    private

    # @return [String, nil]
    def description
      @options[:description]
    end

    # @note #method is reserved by Kernel.#method ;(
    # @return [String]
    def http_method
      @options[:method] || DEFAULT_HTTP_METHOD
    end

    # @return [String, nil]
    def media_type
      @options[:media_type]
    end

    # @return [String]
    def path
      @options[:path]
    end

    # @return [String, nil]
    def rel
      @options[:rel]
    end

    # @return [Hash{Symbol => Object}, nil]
    def schema
      if @options[:parameters]
        JsonWorld::PropertyDefinition.new(
          properties: @options[:parameters],
          property_name: :schema,
        ).as_json_schema
      end
    end

    # @return [Hash{Symbol => Object}, nil]
    def target_schema
      if @options[:target_schema]
        JsonWorld::PropertyDefinition.new(
          properties: @options[:target_schema],
          property_name: :targetSchema,
        ).as_json_schema
      end
    end

    # @return [String]
    def title
      @options[:title] || @link_name.to_s
    end
  end
end
