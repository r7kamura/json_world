RSpec.describe JsonWorld::PropertyDefinable do
  describe ".define_property" do
    let(:property_klass) do
      Class.new do
        include JsonWorld::PropertyDefinable

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

    it "appends JsonWorld::PropertyDefinition" do
      expect(property_klass.property_definitions[0].property_name).to eq :id
      expect(property_klass.property_definitions[1].property_name).to eq :name
    end
  end
end
