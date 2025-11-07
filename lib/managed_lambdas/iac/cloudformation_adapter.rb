# frozen_string_literal: true

require "aws-sdk-cloudformation"
require "aws-sdk-lambda"
require "yaml"

module ManagedLambdas
  module IAC
    class CloudFormationAdapter < BaseAdapter
      def initialize(lambda_spec, config = ManagedLambdas.configuration)
        super
        @cfn_client = Aws::CloudFormation::Client.new(region: config.aws_region)
        @lambda_client = Aws::Lambda::Client.new(region: config.aws_region)
      end

      def deploy
        OTEL::Instrumentation.trace("cloudformation_deploy") do
          stack_name = "managed-lambda-#{lambda_name}"
          template_body = generate_cloudformation_template

          begin
            @cfn_client.create_stack(
              stack_name: stack_name,
              template_body: template_body,
              capabilities: ["CAPABILITY_IAM"]
            )
            
            wait_for_stack_creation(stack_name)
            { success: true, stack_name: stack_name }
          rescue Aws::CloudFormation::Errors::AlreadyExistsException
            # Stack already exists, update it
            @cfn_client.update_stack(
              stack_name: stack_name,
              template_body: template_body,
              capabilities: ["CAPABILITY_IAM"]
            )
            
            wait_for_stack_update(stack_name)
            { success: true, stack_name: stack_name, updated: true }
          end
        end
      end

      def detect
        OTEL::Instrumentation.trace("cloudformation_detect") do
          stack_name = "managed-lambda-#{lambda_name}"
          
          begin
            response = @cfn_client.describe_stacks(stack_name: stack_name)
            { exists: true, stack: response.stacks.first }
          rescue Aws::CloudFormation::Errors::ValidationError
            { exists: false }
          end
        end
      end

      def manage(action)
        OTEL::Instrumentation.trace("cloudformation_manage") do
          case action
          when "enable"
            enable_lambda
          when "disable"
            disable_lambda
          when "get_status"
            get_lambda_status
          else
            raise DeploymentError, "Unknown action: #{action}"
          end
        end
      end

      private

      def generate_cloudformation_template
        template = {
          "AWSTemplateFormatVersion" => "2010-09-09",
          "Description" => "Managed Lambda: #{lambda_name}",
          "Resources" => {
            "LambdaExecutionRole" => {
              "Type" => "AWS::IAM::Role",
              "Properties" => {
                "AssumeRolePolicyDocument" => {
                  "Version" => "2012-10-17",
                  "Statement" => [{
                    "Effect" => "Allow",
                    "Principal" => { "Service" => "lambda.amazonaws.com" },
                    "Action" => "sts:AssumeRole"
                  }]
                },
                "ManagedPolicyArns" => [
                  "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
                ]
              }
            },
            "LambdaFunction" => {
              "Type" => "AWS::Lambda::Function",
              "Properties" => {
                "FunctionName" => lambda_name,
                "Runtime" => lambda_runtime,
                "Handler" => lambda_handler,
                "Role" => { "Fn::GetAtt" => ["LambdaExecutionRole", "Arn"] },
                "Code" => {
                  "ZipFile" => "# Placeholder code"
                },
                "MemorySize" => lambda_memory_size,
                "Timeout" => lambda_timeout,
                "Environment" => {
                  "Variables" => lambda_environment_variables
                }
              }
            }
          }
        }

        YAML.dump(template)
      end

      def wait_for_stack_creation(stack_name)
        @cfn_client.wait_until(:stack_create_complete, stack_name: stack_name)
      end

      def wait_for_stack_update(stack_name)
        @cfn_client.wait_until(:stack_update_complete, stack_name: stack_name)
      end

      def enable_lambda
        # Enable Lambda by updating its concurrency
        @lambda_client.delete_function_concurrency(function_name: lambda_name)
        { success: true, message: "Lambda enabled" }
      end

      def disable_lambda
        # Disable Lambda by setting concurrency to 0
        @lambda_client.put_function_concurrency(
          function_name: lambda_name,
          reserved_concurrent_executions: 0
        )
        { success: true, message: "Lambda disabled" }
      end

      def get_lambda_status
        response = @lambda_client.get_function(function_name: lambda_name)
        {
          success: true,
          status: response.configuration.state,
          last_modified: response.configuration.last_modified
        }
      rescue Aws::Lambda::Errors::ResourceNotFoundException
        { success: false, message: "Lambda not found" }
      end
    end
  end
end
