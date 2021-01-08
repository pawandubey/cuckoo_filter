# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cuckoo_filter/version'

Gem::Specification.new do |spec|
  spec.name          = "cuckoo_filter"
  spec.version       = CuckooFilter::VERSION
  spec.authors       = ["Pawan Dubey"]
  spec.email         = ["hi@pawandubey.com"]

  spec.summary       = %q{Cuckoo Filter implementation in Ruby}
  spec.homepage      = "https://github.com/pawandubeycuckoo_filter"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "codecov"
  spec.add_development_dependency "benchmark-ips"

  spec.add_runtime_dependency "fnv-hash"
end
