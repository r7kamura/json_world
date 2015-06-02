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
        href: path,
        method: http_method,
        title: title,
      }.reject do |_key, value|
        value.nil? || value.empty?
      end
    end

    private

    # @note #method is reserved by Kernel.#method ;(
    # @return [String]
    def http_method
      @options[:method] || DEFAULT_HTTP_METHOD
    end

    # @return [String]
    def path
      @options[:path]
    end

    # @return [String]
    def title
      @options[:title] || @link_name.to_s
    end
  end
end
