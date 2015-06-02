# JsonWorld
Provides DSL to define JSON Schema representation of your class.

## Usage
```rb
class User
  include JsonWorld::PropertyDefinable

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

  attr_reader :id, :name

  # @param [Integer] id
  # @param [String] name
  def initialize(id: nil, name: nil)
    @id = id
    @name = name
  end
end

User.new(id: 1, name: "alice").to_json
# '{"id":1,"name":"alice"}'

User.to_json_schema
# '{
#   "links": [
#     {
#       "href": "/users/:user_id",
#       "title": "get_user"
#     }
#   ],
#   "properties": {
#     "id": {
#       "example": 1,
#       "type": "integer"
#     },
#     "name": {
#       "example": "alice",
#       "pattern": "^\\w{5}$",
#       "type": "string"
#     }
#   },
#   "required": [
#     "id",
#     "name"
#   ]
# }'
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem "json_world"
```
