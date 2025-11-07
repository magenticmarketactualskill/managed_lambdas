# frozen_string_literal: true

require_relative "lib/managed_lambdas/version"

Gem::Specification.new do |spec|
  spec.name = "managed_lambdas"
  spec.version = ManagedLambdas::VERSION
  spec.authors = ["Manus AI"]
  spec.email = ["info@manus.im"]

  spec.summary = "Comprehensive Lambda lifecycle management with multi-language and multi-IAC support"
  spec.description = <<~DESC
    managed_lambdas is a Ruby gem that provides comprehensive lifecycle management for serverless functions (Lambdas).
    It supports multiple implementation languages (Ruby, Rust), multiple IAC platforms (CloudFormation, CDK, Pulumi, DockerDesktop),
    full lifecycle management, Kafka integration, and OpenTelemetry logging. Lambda specifications are defined using SHACL shapes
    via the data_shapes gem.
  DESC
  spec.homepage = "https://github.com/magenticmarketactualskill/managed_lambdas"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3.6"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[
    lib/**/*.rb
    templates/**/*
    bin/*
    *.md
    LICENSE
  ]).reject { |f| File.directory?(f) }
  
  spec.bindir = "bin"
  spec.executables = ["managed_lambdas"]
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "faraday", "~> 2.0"
  spec.add_dependency "faraday-multipart", "~> 1.0"
  spec.add_dependency "thor", "~> 1.3"
  spec.add_dependency "rdf", "~> 3.3"
  spec.add_dependency "shacl", "~> 0.3"
  spec.add_dependency "opentelemetry-sdk", "~> 1.0"
  spec.add_dependency "opentelemetry-instrumentation-all", "~> 0.50"
  spec.add_dependency "ruby-kafka", "~> 1.5"
  spec.add_dependency "aws-sdk-cloudformation", "~> 1.0"
  spec.add_dependency "aws-sdk-lambda", "~> 1.0"

  # Development dependencies
  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "cucumber", "~> 9.0"
  spec.add_development_dependency "webmock", "~> 3.23"
  spec.add_development_dependency "vcr", "~> 6.2"
  spec.add_development_dependency "rubocop", "~> 1.60"
  spec.add_development_dependency "rubocop-rspec", "~> 2.27"
  spec.add_development_dependency "yard", "~> 0.9"
end
