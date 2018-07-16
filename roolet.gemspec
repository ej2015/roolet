# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'roolet/version'

Gem::Specification.new do |spec|
  spec.name          = "roolet"
  spec.version       = Roolet::VERSION
  spec.authors       = ["Edgar"]
  spec.email         = ["zorro.ej@gmail.com"]

  spec.summary       = %q{A simple wrapper of Roo to provide a more intuitive interface.}
  spec.description   = %q{Parse and convert a file the way you'd expect}
  spec.homepage      = "https://github.com/ej2015/roolet.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

	spec.add_dependency "roo", "~> 2.7.1"

	spec.add_development_dependency 'pry-byebug'
#	spec.add_development_dependency 'activesupport', "~> 5.2.0"
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.7"
end
