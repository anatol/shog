Gem::Specification.new do |spec|
  spec.name = "shog-build"
  spec.version = "0.1.0"
  spec.platform = Gem::Platform::RUBY
  spec.authors = ["Anatol Pomozov"]
  spec.email = ["anatol.pomozov@gmail.com"]
  spec.homepage = "https://github.com/anatol/shog"
  spec.summary = "Ruby frontend for Ninja build system"
  spec.license = "MIT"

  if File.exist?(Gem.default_key_path) && File.exist?(Gem.default_cert_path)
    spec.signing_key = Gem.default_key_path
    spec.cert_chain = [Gem.default_cert_path]
  end

  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.7"

  spec.files = Dir["lib/**/*"]
  spec.executables = %w(shog)
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.require_paths = ["lib"]
end
