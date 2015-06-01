RSpec.describe JsonSchemaWorld::Property do
  describe ".define_property" do
    let(:property_klass) do
      Class.new do
        include JsonSchemaWorld::Property

        define_property(
          :id,
          example: 42,
          type: Integer,
        )

        define_property(
          :name,
          example: "r7kamura",
          type: String,
        )

        attr_reader :id, :name

        def initialize(id:, name:)
          @id = id
          @name = name
        end
      end
    end

    it "appends JsonSchemaWorld::PropertyDefinition" do
      expect(property_klass.properties[0].property_name).to eq :id
      expect(property_klass.properties[1].property_name).to eq :name
    end
  end
end
