# frozen_string_literal: true
lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "resolvme/version"

Gem::Specification.new do |spec| # rubocop:disable Metrics/BlockLength
  spec.name          = "resolvme"
  spec.version       = Resolvme::VERSION
  spec.authors       = ["Citizens Advice"]
  spec.email         = ["ca-devops@citizensadvice.org.uk"]

  spec.summary       = "Resolvers"
  spec.description   = "Resolvers"
  spec.homepage      = "https://github.com/citizensadvice/resolvme"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  raise "RubyGems 2.0 or newer is required to protect against public gem pushes." unless spec.respond_to?(:metadata)

  spec.metadata["source_code_uri"] = "https://github.com/citizensadvice/resolvme"
  spec.metadata["changelog_uri"] = "https://github.com/citizensadvice/resolvme/CHANGELOG.md"
  spec.metadata["allowed_push_host"] = "https://nexus.devops.citizensadvice.org.uk/repository/citizensadvice/"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = ["bin"]
  spec.executables   = ["resolvme"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = "~> 2.6.5"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "nexus", "~> 1.4"
  spec.add_development_dependency "pry", "~> 0.13.0"
  spec.add_development_dependency "pry-byebug", "~> 3.8"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rdoc", "~> 6.2"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "simplecov", "~> 0.18.0"
  spec.add_development_dependency "yard", "~> 0.9.0"
  spec.add_dependency "aws-sdk-acm", "~> 1.24"
  spec.add_dependency "aws-sdk-cloudformation", "~> 1.24"
  spec.add_dependency "vault", "~> 0.15.0"
end
