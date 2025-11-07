# frozen_string_literal: true

module ManagedLambdas
  class Configuration
    attr_accessor :data_shapes_url,
                  :otel_exporter,
                  :otel_service_name,
                  :kafka_brokers,
                  :kafka_client_id,
                  :default_iac_platform,
                  :default_language,
                  :aws_region

    def initialize
      @data_shapes_url = ENV.fetch("DATA_SHAPES_URL", "http://localhost:3000/data_shapes/api/v1")
      @otel_exporter = ENV.fetch("OTEL_EXPORTER", "console")
      @otel_service_name = ENV.fetch("OTEL_SERVICE_NAME", "managed_lambdas")
      @kafka_brokers = ENV.fetch("KAFKA_BROKERS", "localhost:9092").split(",")
      @kafka_client_id = ENV.fetch("KAFKA_CLIENT_ID", "managed_lambdas")
      @default_iac_platform = ENV.fetch("DEFAULT_IAC_PLATFORM", "cloudformation")
      @default_language = ENV.fetch("DEFAULT_LANGUAGE", "ruby")
      @aws_region = ENV.fetch("AWS_REGION", "us-east-1")
    end

    def validate!
      raise ConfigurationError, "data_shapes_url cannot be blank" if data_shapes_url.nil? || data_shapes_url.empty?
      raise ConfigurationError, "kafka_brokers cannot be empty" if kafka_brokers.empty?
      raise ConfigurationError, "aws_region cannot be blank" if aws_region.nil? || aws_region.empty?
    end
  end
end
