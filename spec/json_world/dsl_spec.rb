RSpec.describe JsonWorld::DSL do
  let(:klass) do
    Class.new do
      include JsonWorld::DSL

      title "Dummy object"

      description "A dummy object for testing"

      property(
        :created_at,
        description: "The time when this user was born",
        example: "2000-01-01T00:00:00+00:00",
        type: Time,
      )

      property(
        :id,
        description: "An unique ID assigned to each user",
        example: 1,
        type: Integer,
      )

      property(
        :name,
        description: "The name of this user",
        example: "alice",
        optional: true,
        pattern: /^\w{5}$/,
        type: [NilClass, String],
      )

      property(
        :stats,
        properties: {
          articles_count: {
            description: "How many articles this user has posted",
            example: 10,
            type: Integer,
          },
        },
        type: Hash,
      )

      property(
        :tags,
        example: ["male"],
        items: {
          description: "An arbitrary tag",
          pattern: /^\w{3,20}$/,
          type: String,
        },
        type: Array,
        unique: true,
      )

      link(
        :get_user,
        description: "Get a single user",
        path: "/users/:user_id",
        rel: "self",
      )

      link(
        :create_user,
        description: "Create a new user",
        method: "POST",
        parameters: {
          name: {
            description: "The name of this user",
            example: "alice",
            optional: true,
            pattern: /^\w{5}$/,
            type: [NilClass, String],
          },
        },
        path: "/users",
      )

      attr_reader(
        :created_at,
        :id,
        :name,
        :tags,
      )

      def initialize(articles_count:, id:, name:, tags:)
        @articles_count = articles_count
        @created_at = Time.now
        @id = id
        @name = name
        @tags = tags
      end

      # @return [Hash{Symbol => Integer}]
      def stats
        { articles_count: @articles_count }
      end
    end
  end

  describe ".as_json_schema" do
    subject do
      klass.as_json_schema
    end

    it "returns the JSON Schema representation of the receiver class" do
      is_expected.to eq(
        description: "A dummy object for testing",
        links: [
          {
            description: "Get a single user",
            href: "/users/:user_id",
            method: "GET",
            rel: "self",
            title: "get_user",
          },
          {
            description: "Create a new user",
            href: "/users",
            method: "POST",
            schema: {
              properties: {
                name: {
                  description: "The name of this user",
                  example: "alice",
                  pattern: '^\w{5}$',
                  type: ["null", "string"],
                },
              },
            },
            title: "create_user",
          },
        ],
        properties: {
          created_at: {
            description: "The time when this user was born",
            example: "2000-01-01T00:00:00+00:00",
            format: "date-time",
            type: "string",
          },
          id: {
            description: "An unique ID assigned to each user",
            example: 1,
            type: "integer",
          },
          name: {
            description: "The name of this user",
            example: "alice",
            pattern: '^\w{5}$',
            type: ["null", "string"],
          },
          stats: {
            properties: {
              articles_count: {
                description: "How many articles this user has posted",
                example: 10,
                type: "integer",
              },
            },
            required: [:articles_count],
            type: "object",
          },
          tags: {
            example: ["male"],
            items: {
              description: "An arbitrary tag",
              pattern: '^\w{3,20}$',
              type: "string",
            },
            type: "array",
            uniqueItems: true,
          },
        },
        required: [
          :created_at,
          :id,
          :stats,
          :tags,
        ],
        title: "Dummy object",
      )
    end
  end

  describe "#as_json" do
    subject do
      klass.new(
        articles_count: 10,
        id: 1,
        name: "alice",
        tags: ["female", "teenage"],
      ).as_json
    end

    it "returns a JSON compatible hash representation of the instance" do
      is_expected.to match(
        hash_including(
          "created_at" => instance_of(String),
          "id" => 1,
          "name" => "alice",
          "stats" => {
            "articles_count" => 10,
          },
          "tags" => ["female", "teenage"],
        )
      )
    end
  end
end
