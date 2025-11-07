# frozen_string_literal: true

module ManagedLambdas
  module IAC
    class BaseAdapter
      attr_reader :lambda_spec, :config

      def initialize(lambda_spec, config = ManagedLambdas.configuration)
        @lambda_spec = lambda_spec
        @config = config
      end

      # Deploy a Lambda to the IAC platform
      def deploy
        raise NotImplementedError, "#{self.class}#deploy must be implemented"
      end

      # Detect if a Lambda exists in the IAC platform
      def detect
        raise NotImplementedError, "#{self.class}#detect must be implemented"
      end

      # Manage a Lambda (enable, disable, get_status)
      def manage(action)
        raise NotImplementedError, "#{self.class}#manage must be implemented"
      end

      # Get the Lambda name from the spec
      def lambda_name
        @lambda_spec.dig("data_shape", "name") || @lambda_spec["name"]
      end

      # Get the Lambda handler from the spec
      def lambda_handler
        extract_property("handler") || "handler.main"
      end

      # Get the Lambda memory size from the spec
      def lambda_memory_size
        extract_property("memory_size") || 128
      end

      # Get the Lambda timeout from the spec
      def lambda_timeout
        extract_property("timeout") || 30
      end

      # Get the Lambda environment variables from the spec
      def lambda_environment_variables
        extract_property("environment_variables") || {}
      end

      # Get the Lambda runtime from the spec
      def lambda_runtime
        language = extract_property("language") || "ruby"
        case language
        when "ruby"
          "ruby3.3"
        when "rust"
          "provided.al2023"
        else
          raise DeploymentError, "Unsupported language: #{language}"
        end
      end

      private

      # Extract a property from the SHACL definition
      def extract_property(property_name)
        # This is a simplified extraction
        # In a real implementation, you would parse the SHACL definition
        # and extract the property value
        nil
      end
    end
  end
end
