## Unreleased

- Provides options method to reuse args for property definition except property name

## 0.3.0

- Fix keyword arguments error for Ruby 3 support.

## 0.2.6

- Use `#__send__` instead of `#send`

## 0.2.5

- Remove unnecessary dependency on json

## 0.2.4

- Support `$schema` property

## 0.2.3

- Add :target_schema option on link definition

## 0.2.2

- Support :media_type option on link definition

## 0.2.1

- Provides raw_options method to reuse args for property definition

## 0.2.0

- Support :links option on embedding other resource as property

## 0.1.4

- Rename as_json_schema_without_link with as_json_schema_without_links

## 0.1.3

- Support boolean type on property definition

## 0.1.2

- Remove links property from embedded object
- Fix bug that links are unexpectedly shared by other classes

## 0.1.1

- Support embedding other JSON-Schema compatible object via type
- Support rel property on LinkDefinition

## 0.1.0

- Rename included module name: PropertyDefinable -> DSL

## 0.0.1

- 1st Release
