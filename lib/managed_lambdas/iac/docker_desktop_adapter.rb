# frozen_string_literal: true

module ManagedLambdas
  module IAC
    class DockerDesktopAdapter < BaseAdapter
      def deploy
        OTEL::Instrumentation.trace("docker_desktop_deploy") do
          raise NotImplementedError, "docker_desktop adapter not yet implemented"
        end
      end

      def detect
        OTEL::Instrumentation.trace("docker_desktop_detect") do
          raise NotImplementedError, "docker_desktop adapter not yet implemented"
        end
      end

      def manage(action)
        OTEL::Instrumentation.trace("docker_desktop_manage") do
          raise NotImplementedError, "docker_desktop adapter not yet implemented"
        end
      end
    end
  end
end
