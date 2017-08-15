module JsonWorld
  module JsonEncodable
    # @param [Hash{Symbol => Object}] options :except / :only
    # @return [Hash]
    def as_json(options = {})
      properties(options).as_json(options)
    end

    private

    # @note receiver.class.property_names must be implemented
    # @param [Hash{Symbol => Object}] options :except / :only
    # @return [Hash]
    def properties(options = {})
      names = self.class.property_names
      names = names - Array(options[:except]) if options[:except]
      names = names & Array(options[:only]) if options[:only]
      names.inject({}) do |hash, property_name|
        key = property_name
        value = __send__(property_name)
        value = value.iso8601 if value.is_a?(Time)
        hash.merge(key => value)
      end
    end
  end
end
