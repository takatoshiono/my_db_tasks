# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'my_db_tasks/version'

Gem::Specification.new do |spec|
  spec.name          = "my_db_tasks"
  spec.version       = MyDbTasks::VERSION
  spec.authors       = ["Takatoshi Ono"]
  spec.email         = ["takatoshi.ono@gmail.com"]

  spec.summary       = %q{my db tasks}
  spec.description   = %q{my db tasks}
  spec.homepage      = "https://github.com/takatoshiono/my_db_tasks"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "activerecord", "~> 5.0"
  spec.add_dependency "activesupport", "~> 5.0"
  spec.add_dependency "mysql2"
end
