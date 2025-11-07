# managed_lambdas

[![Ruby](https://img.shields.io/badge/ruby-3.3.6-red.svg)](https://www.ruby-lang.org/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

**managed_lambdas** is a comprehensive Ruby gem for managing the full lifecycle of serverless functions (Lambdas). It provides a unified interface for creating, deploying, and managing Lambdas across multiple implementation languages and Infrastructure as Code (IAC) platforms.

## Features

- **Multi-Language Support**: Create Lambdas in Ruby or Rust
- **Multi-IAC Platform Support**: Deploy to AWS CloudFormation, AWS CDK (Python/Go), Pulumi (Python/Go), or DockerDesktop
- **Full Lifecycle Management**: From specification to deployment and management
- **Data Shapes Integration**: Define Lambda specifications using SHACL shapes via the `data_shapes` gem
- **Kafka Integration**: Publish and subscribe to Kafka topics (generic or AWS MSK)
- **OpenTelemetry Logging**: Built-in distributed tracing, metrics, and logging
- **Automated Testing**: Generate and run RSpec tests for Lambda logic and IAC configurations

## Architecture

The gem is built on a modular architecture with the following key components:

- **Core**: Central orchestrator providing a unified API
- **Data Shapes Integration**: Manages Lambda specifications using SHACL validation
- **IAC Adapters**: Pluggable system for supporting multiple IAC platforms
- **Language Support**: Templates and build tools for different languages
- **Lifecycle Manager**: Manages the full Lambda lifecycle
- **Kafka Integration**: Tools for Kafka pub/sub
- **OTEL Logging**: OpenTelemetry instrumentation

## Requirements

- Ruby >= 3.3.6
- Access to a running `data_shapes` service
- AWS credentials (for AWS-based IAC platforms)
- Kafka brokers (for Kafka integration)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'managed_lambdas'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install managed_lambdas
```

## Configuration

Configure the gem in an initializer or before use:

```ruby
ManagedLambdas.configure do |config|
  config.data_shapes_url = 'http://localhost:3000/data_shapes/api/v1'
  config.otel_exporter = 'console'
  config.kafka_brokers = ['localhost:9092']
  config.default_iac_platform = 'cloudformation'
  config.default_language = 'ruby'
  config.aws_region = 'us-east-1'
end
```

You can also use environment variables:

```bash
export DATA_SHAPES_URL=http://localhost:3000/data_shapes/api/v1
export OTEL_EXPORTER=console
export KAFKA_BROKERS=localhost:9092
export DEFAULT_IAC_PLATFORM=cloudformation
export DEFAULT_LANGUAGE=ruby
export AWS_REGION=us-east-1
```

## Usage

### Command Line Interface

The gem provides a CLI for common operations:

```bash
# Create a Lambda specification
$ managed_lambdas create-spec hello_world --description "My first Lambda" --language ruby

# Get a Lambda specification
$ managed_lambdas get-spec hello_world

# Generate tests for a Lambda
$ managed_lambdas generate-tests hello_world

# Run tests for a Lambda
$ managed_lambdas run-tests hello_world

# Deploy a Lambda
$ managed_lambdas deploy hello_world --iac_platform cloudformation

# Detect if a Lambda exists
$ managed_lambdas detect hello_world

# Manage a Lambda
$ managed_lambdas manage hello_world enable
$ managed_lambdas manage hello_world disable
$ managed_lambdas manage hello_world get_status
```

### Programmatic API

You can also use the gem programmatically:

```ruby
require 'managed_lambdas'

# Initialize the core
core = ManagedLambdas::Core.new

# Create a specification
spec_details = {
  name: 'hello_world',
  description: 'My first Lambda',
  language: 'ruby',
  iac_platform: 'cloudformation'
}
core.create_specification(spec_details)

# Deploy the Lambda
core.deploy('hello_world')

# Manage the Lambda
core.manage('hello_world', 'enable')
```

### Kafka Integration

```ruby
# Initialize Kafka client
kafka_client = ManagedLambdas::Kafka::Client.new

# Publish a message
kafka_client.publish('my-topic', 'Hello, Kafka!')

# Subscribe to a topic
kafka_client.subscribe('my-topic') do |message|
  puts "Received: #{message.value}"
end

# Subscribe and invoke Lambda
kafka_client.subscribe_and_invoke_lambda('my-topic', 'hello_world')
```

### OpenTelemetry Instrumentation

```ruby
# Setup OTEL instrumentation
ManagedLambdas::OTEL::Instrumentation.setup

# Create a trace
ManagedLambdas::OTEL::Instrumentation.trace('my_operation') do |span|
  span.set_attribute('custom.attribute', 'value')
  # Your code here
end
```

## Supported IAC Platforms

| Platform | Status | Description |
|----------|--------|-------------|
| AWS CloudFormation | ✅ Implemented | Deploy using CloudFormation YAML templates |
| AWS CDK (Python) | 🚧 Planned | Deploy using AWS CDK with Python |
| AWS CDK (Go) | 🚧 Planned | Deploy using AWS CDK with Go |
| Pulumi (Python) | 🚧 Planned | Deploy using Pulumi with Python |
| Pulumi (Go) | 🚧 Planned | Deploy using Pulumi with Go |
| DockerDesktop | 🚧 Planned | Deploy to local Docker environment |

## Supported Languages

| Language | Status | Description |
|----------|--------|-------------|
| Ruby | ✅ Implemented | Ruby 3.3+ Lambda functions |
| Rust | ✅ Implemented | Rust Lambda functions (custom runtime) |

## Development

After checking out the repo, run:

```bash
$ bundle install
```

Run the tests:

```bash
$ bundle exec rspec
$ bundle exec cucumber
```

Run the linter:

```bash
$ bundle exec rubocop
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](LICENSE).

## Credits

This gem was designed and implemented by **Manus AI** based on requirements for comprehensive Lambda lifecycle management with semantic data shapes integration.
