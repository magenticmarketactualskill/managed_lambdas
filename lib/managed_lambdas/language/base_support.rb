# frozen_string_literal: true

module ManagedLambdas
  module Language
    class BaseSupport
      attr_reader :lambda_spec, :config

      def initialize(lambda_spec, config = ManagedLambdas.configuration)
        @lambda_spec = lambda_spec
        @config = config
      end

      # Generate a new Lambda project from template
      def generate_project(output_dir)
        raise NotImplementedError, "#{self.class}#generate_project must be implemented"
      end

      # Build and package the Lambda
      def build_package(project_dir)
        raise NotImplementedError, "#{self.class}#build_package must be implemented"
      end

      # Get the Lambda name from the spec
      def lambda_name
        @lambda_spec.dig("data_shape", "name") || @lambda_spec["name"]
      end

      protected

      # Copy template files to output directory
      def copy_template(template_name, output_dir)
        template_dir = File.join(__dir__, "../../templates", template_name)
        FileUtils.cp_r(template_dir, output_dir)
      end

      # Replace placeholders in files
      def replace_placeholders(file_path, replacements)
        content = File.read(file_path)
        replacements.each do |placeholder, value|
          content.gsub!("{{#{placeholder}}}", value.to_s)
        end
        File.write(file_path, content)
      end
    end
  end
end
