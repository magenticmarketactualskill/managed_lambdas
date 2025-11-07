# frozen_string_literal: true

module ManagedLambdas
  module IAC
    class PulumiGoAdapter < BaseAdapter
      def deploy
        OTEL::Instrumentation.trace("pulumi_go_deploy") do
          raise NotImplementedError, "pulumi_go adapter not yet implemented"
        end
      end

      def detect
        OTEL::Instrumentation.trace("pulumi_go_detect") do
          raise NotImplementedError, "pulumi_go adapter not yet implemented"
        end
      end

      def manage(action)
        OTEL::Instrumentation.trace("pulumi_go_manage") do
          raise NotImplementedError, "pulumi_go adapter not yet implemented"
        end
      end
    end
  end
end
