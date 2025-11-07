# frozen_string_literal: true

module ManagedLambdas
  module IAC
    class CdkPythonAdapter < BaseAdapter
      def deploy
        OTEL::Instrumentation.trace("cdk_python_deploy") do
          # TODO: Implement CDK Python deployment
          raise NotImplementedError, "CDK Python adapter not yet implemented"
        end
      end

      def detect
        OTEL::Instrumentation.trace("cdk_python_detect") do
          # TODO: Implement CDK Python detection
          raise NotImplementedError, "CDK Python adapter not yet implemented"
        end
      end

      def manage(action)
        OTEL::Instrumentation.trace("cdk_python_manage") do
          # TODO: Implement CDK Python management
          raise NotImplementedError, "CDK Python adapter not yet implemented"
        end
      end
    end
  end
end
