# JsonWorld
Provides DSL to define JSON Schema representation of your class.

## Usage
```rb
class User
  include JsonWorld::PropertyDefinable

  property(
    :id,
    example: 42,
    type: Integer,
  )

  property(
    :name,
    example: "r7kamura",
    type: String,
  )

  attr_reader :id, :name

  # @param [Integer] id
  # @param [String] name
  def initialize(id: nil, name: nil)
    @id = id
    @name = name
  end
end

User.new(id: 1, name: "alice").to_json
#=> '{"id":1,"name":"alice"}'

User.as_json_schema
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem "json_world"
```
