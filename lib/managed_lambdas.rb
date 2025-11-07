# frozen_string_literal: true

require_relative "managed_lambdas/version"
require_relative "managed_lambdas/configuration"
require_relative "managed_lambdas/core"
require_relative "managed_lambdas/data_shapes/client"
require_relative "managed_lambdas/iac/base_adapter"
require_relative "managed_lambdas/iac/cloudformation_adapter"
require_relative "managed_lambdas/iac/cdk_python_adapter"
require_relative "managed_lambdas/iac/cdk_go_adapter"
require_relative "managed_lambdas/iac/pulumi_python_adapter"
require_relative "managed_lambdas/iac/pulumi_go_adapter"
require_relative "managed_lambdas/iac/docker_desktop_adapter"
require_relative "managed_lambdas/language/base_support"
require_relative "managed_lambdas/language/ruby_support"
require_relative "managed_lambdas/language/rust_support"
require_relative "managed_lambdas/lifecycle_manager"
require_relative "managed_lambdas/kafka/client"
require_relative "managed_lambdas/otel/instrumentation"

module ManagedLambdas
  class Error < StandardError; end
  class ConfigurationError < Error; end
  class SpecificationError < Error; end
  class DeploymentError < Error; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  def self.reset_configuration!
    self.configuration = Configuration.new
  end
end
