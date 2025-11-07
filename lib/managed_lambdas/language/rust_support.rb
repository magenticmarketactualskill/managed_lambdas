# frozen_string_literal: true

require "fileutils"

module ManagedLambdas
  module Language
    class RustSupport < BaseSupport
      def generate_project(output_dir)
        OTEL::Instrumentation.trace("rust_generate_project") do
          FileUtils.mkdir_p(output_dir)
          copy_template("rust", output_dir)
          
          # Replace placeholders in template files
          replacements = {
            "LAMBDA_NAME" => lambda_name,
            "LAMBDA_DESCRIPTION" => lambda_description
          }
          
          Dir.glob("#{output_dir}/**/*").each do |file|
            next if File.directory?(file)
            replace_placeholders(file, replacements)
          end

          { success: true, output_dir: output_dir }
        end
      end

      def build_package(project_dir)
        OTEL::Instrumentation.trace("rust_build_package") do
          # Build for AWS Lambda (Amazon Linux 2)
          system("cd #{project_dir} && cargo build --release --target x86_64-unknown-linux-musl")
          
          # Create deployment package
          package_file = "#{project_dir}/lambda_package.zip"
          system("cd #{project_dir}/target/x86_64-unknown-linux-musl/release && zip #{package_file} bootstrap")
          
          { success: true, package_file: package_file }
        end
      end

      private

      def lambda_description
        @lambda_spec.dig("data_shape", "description") || "A managed Lambda function"
      end
    end
  end
end
