# frozen_string_literal: true

module ManagedLambdas
  module IAC
    class PulumiPythonAdapter < BaseAdapter
      def deploy
        OTEL::Instrumentation.trace("pulumi_python_deploy") do
          raise NotImplementedError, "pulumi_python adapter not yet implemented"
        end
      end

      def detect
        OTEL::Instrumentation.trace("pulumi_python_detect") do
          raise NotImplementedError, "pulumi_python adapter not yet implemented"
        end
      end

      def manage(action)
        OTEL::Instrumentation.trace("pulumi_python_manage") do
          raise NotImplementedError, "pulumi_python adapter not yet implemented"
        end
      end
    end
  end
end
