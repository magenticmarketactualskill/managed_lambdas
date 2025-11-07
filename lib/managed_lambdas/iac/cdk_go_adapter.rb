# frozen_string_literal: true

module ManagedLambdas
  module IAC
    class CdkGoAdapter < BaseAdapter
      def deploy
        OTEL::Instrumentation.trace("cdk_go_deploy") do
          raise NotImplementedError, "cdk_go adapter not yet implemented"
        end
      end

      def detect
        OTEL::Instrumentation.trace("cdk_go_detect") do
          raise NotImplementedError, "cdk_go adapter not yet implemented"
        end
      end

      def manage(action)
        OTEL::Instrumentation.trace("cdk_go_manage") do
          raise NotImplementedError, "cdk_go adapter not yet implemented"
        end
      end
    end
  end
end
