# frozen_string_literal: true

require "opentelemetry/sdk"
require "opentelemetry/instrumentation/all"

module ManagedLambdas
  module OTEL
    module Instrumentation
      class << self
        attr_accessor :configured

        # Setup OpenTelemetry instrumentation
        def setup(config = ManagedLambdas.configuration)
          return if @configured

          OpenTelemetry::SDK.configure do |c|
            c.service_name = config.otel_service_name
            c.service_version = ManagedLambdas::VERSION
            
            # Configure exporter based on configuration
            case config.otel_exporter
            when "console"
              c.add_span_processor(
                OpenTelemetry::SDK::Trace::Export::BatchSpanProcessor.new(
                  OpenTelemetry::SDK::Trace::Export::ConsoleSpanExporter.new
                )
              )
            when "otlp"
              # OTLP exporter would be configured here
              # Requires opentelemetry-exporter-otlp gem
            end

            # Use all available instrumentation
            c.use_all
          end

          @configured = true
        end

        # Create a trace span
        def trace(span_name, attributes: {}, &block)
          setup unless @configured
          
          tracer = OpenTelemetry.tracer_provider.tracer(
            "managed_lambdas",
            version: ManagedLambdas::VERSION
          )
          
          tracer.in_span(span_name, attributes: attributes) do |span|
            block.call(span)
          end
        end

        # Add an event to the current span
        def add_event(name, attributes: {})
          current_span = OpenTelemetry::Trace.current_span
          current_span.add_event(name, attributes: attributes) if current_span
        end

        # Set an attribute on the current span
        def set_attribute(key, value)
          current_span = OpenTelemetry::Trace.current_span
          current_span.set_attribute(key, value) if current_span
        end

        # Record an exception on the current span
        def record_exception(exception)
          current_span = OpenTelemetry::Trace.current_span
          current_span.record_exception(exception) if current_span
        end
      end
    end
  end
end
