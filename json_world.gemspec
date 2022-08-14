lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "json_world/version"

Gem::Specification.new do |spec|
  spec.name          = "json_world"
  spec.version       = JsonWorld::VERSION
  spec.authors       = ["Ryo Nakamura"]
  spec.email         = ["r7kamura@gmail.com"]
  spec.summary       = "Provides DSL to define JSON Schema representation of your class."
  spec.homepage      = "https://github.com/r7kamura/json_world"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
end
