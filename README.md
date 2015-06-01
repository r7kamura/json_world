# JsonSchemaWorld
Provides DSL to define JSON Schema representation of your class.

## Usage
```rb
class User
  # Declare this class is a property of a JSON Schema.
  include JsonSchemaWorld::Property

  # Define User property has id property, which is a Integer type,
  # and might be 42 for example.
  define_property(
    :id,
    example: 42,
    type: Integer,
  )

  # Define User property has name property, which is a String type,
  # and might be "r7kamura" for example.
  define_property(
    :name,
    example: "r7kamura",
    type: String,
  )

  attr_reader :id, :name

  # @param [Integer] id
  # @param [String] name
  def initialize(id:, name:)
    @id = id
    @name = name
  end
end

# Returns a JSON Representation of a User instance,
# that contains id and name properties.
User.new(id: 1, name: "alice").to_json

# Returns a Hash that represents JSON Schema of User class.
User.as_json_schema
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem "json_schema_world"
```
