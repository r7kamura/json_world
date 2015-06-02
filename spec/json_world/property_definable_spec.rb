RSpec.describe JsonWorld::PropertyDefinable do
  let(:klass) do
    Class.new do
      include JsonWorld::PropertyDefinable

      property(
        :created_at,
        example: "2000-01-01T00:00:00+00:00",
        type: Time,
      )

      property(
        :id,
        example: 1,
        type: Integer,
      )

      property(
        :name,
        example: "alice",
        pattern: /^\w{5}$/,
        type: String,
      )

      link(
        :get_user,
        path: "/users/:user_id",
      )

      attr_reader(
        :created_at,
        :id,
        :name,
      )

      def initialize(id:, name:)
        @created_at = Time.now
        @id = id
        @name = name
      end
    end
  end

  describe ".as_json_schema" do
    subject do
      klass.as_json_schema
    end

    it "returns the JSON Schema representation of the receiver class" do
      is_expected.to eq(
        links: [
          {
            href: "/users/:user_id",
            method: "GET",
            title: "get_user",
          },
        ],
        properties: {
          created_at: {
            example: "2000-01-01T00:00:00+00:00",
            format: "date-time",
            type: "string",
          },
          id: {
            example: 1,
            type: "integer",
          },
          name: {
            example: "alice",
            pattern: '^\w{5}$',
            type: "string",
          },
        },
        required: [
          :created_at,
          :id,
          :name,
        ],
      )
    end
  end

  describe "#as_json" do
    subject do
      klass.new(id: 1, name: "alice").as_json
    end

    it "returns a JSON compatible hash representation of the instance" do
      is_expected.to match(
        hash_including(
          "id" => 1,
          "name" => "alice",
        )
      )
    end
  end
end
