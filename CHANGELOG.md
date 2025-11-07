# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2025-11-07

### Added
- Initial release of managed_lambdas gem
- Core module with unified API for Lambda lifecycle management
- Data Shapes integration for SHACL-based Lambda specifications
- IAC adapter system with CloudFormation implementation
- Language support for Ruby and Rust
- Lifecycle Manager for full Lambda lifecycle orchestration
- Kafka integration for pub/sub messaging
- OpenTelemetry instrumentation for distributed tracing and logging
- CLI tool for common operations
- RSpec and Cucumber test frameworks
- Comprehensive documentation and examples

### Supported Features
- Create, read, update, and delete Lambda specifications
- Deploy Lambdas to AWS CloudFormation
- Detect existing Lambdas in IAC platforms
- Manage Lambda state (enable, disable, get_status)
- Generate and run tests for Lambda logic and IAC
- Publish and subscribe to Kafka topics
- Distributed tracing with OpenTelemetry

### Planned Features
- AWS CDK (Python, Go) adapter implementation
- Pulumi (Python, Go) adapter implementation
- DockerDesktop adapter implementation
- Enhanced SHACL property extraction
- Lambda invocation from Kafka messages
- Additional language support (Python, Go, JavaScript)
- Advanced testing capabilities
- CI/CD integration examples

[Unreleased]: https://github.com/magenticmarketactualskill/managed_lambdas/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/magenticmarketactualskill/managed_lambdas/releases/tag/v0.1.0
