# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devise_password_history/version'

Gem::Specification.new do |gem|
  gem.name          = "devise_password_history"
  gem.version       = DevisePasswordHistory::VERSION
  gem.authors       = ["Ryan Heath"]
  gem.email         = ["ryan@rpheath.com"]
  gem.description   = %q{Maintains password history and ensures old passwords aren't reused}
  gem.summary       = %q{Password history support for devise}
  gem.homepage      = "http://github.com/rpheath/devise_password_history"

  gem.add_dependency("devise", ["~> 2.2.0"])

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test)/})
  gem.require_paths = ["lib"]
end