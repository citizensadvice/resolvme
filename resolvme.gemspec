lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "resolvme"
  spec.version       = "0.2.0"
  spec.authors       = ["Michele Sorcinelli"]
  spec.email         = ["michele.sorcinelli@citizensadvice.org.uk"]

  spec.summary       = "Resolvers"
  spec.description   = "Resolvers"
  spec.homepage      = "https://github.com/citizensadvice/resolvme"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = ["bin"]
  spec.executables   = ["resolvme"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0.1"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "rdoc"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_dependency "vault", "~> 0.12"
  spec.add_dependency "aws-sdk-cloudformation", "~> 1.24"
  spec.add_dependency "aws-sdk-acm", "~> 1.24"
end
