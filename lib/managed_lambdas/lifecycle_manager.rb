# frozen_string_literal: true

module ManagedLambdas
  class LifecycleManager
    attr_reader :lambda_spec, :iac_adapter, :language_support, :config

    def initialize(lambda_spec, iac_platform: nil, config: ManagedLambdas.configuration)
      @lambda_spec = lambda_spec
      @config = config
      @iac_adapter = create_iac_adapter(iac_platform)
      @language_support = create_language_support
    end

    # Generate tests for the Lambda
    def generate_tests
      OTEL::Instrumentation.trace("generate_tests") do
        test_dir = "spec/lambdas/#{lambda_name}"
        FileUtils.mkdir_p(test_dir)

        # Generate logic tests
        generate_logic_tests(test_dir)

        # Generate IAC tests
        generate_iac_tests(test_dir)

        { success: true, test_dir: test_dir }
      end
    end

    # Run tests for the Lambda
    def run_tests
      OTEL::Instrumentation.trace("run_tests") do
        test_dir = "spec/lambdas/#{lambda_name}"
        
        # Run RSpec tests
        result = system("bundle exec rspec #{test_dir}")
        
        { success: result, test_dir: test_dir }
      end
    end

    # Deploy the Lambda
    def deploy
      OTEL::Instrumentation.trace("deploy") do
        # Generate project
        project_dir = "tmp/lambdas/#{lambda_name}"
        @language_support.generate_project(project_dir)

        # Build package
        package_result = @language_support.build_package(project_dir)

        # Deploy using IAC adapter
        @iac_adapter.deploy

        { success: true, project_dir: project_dir, package: package_result }
      end
    end

    # Detect if Lambda exists
    def detect
      OTEL::Instrumentation.trace("detect") do
        @iac_adapter.detect
      end
    end

    # Manage Lambda
    def manage(action)
      OTEL::Instrumentation.trace("manage") do
        @iac_adapter.manage(action)
      end
    end

    private

    def lambda_name
      @lambda_spec.dig("data_shape", "name") || @lambda_spec["name"]
    end

    def lambda_language
      # Extract language from SHACL definition
      # Simplified for now
      @config.default_language
    end

    def lambda_iac_platform
      # Extract IAC platform from SHACL definition
      # Simplified for now
      @config.default_iac_platform
    end

    def create_iac_adapter(iac_platform)
      platform = iac_platform || lambda_iac_platform
      
      case platform
      when "cloudformation"
        IAC::CloudFormationAdapter.new(@lambda_spec, @config)
      when "cdk_python"
        IAC::CdkPythonAdapter.new(@lambda_spec, @config)
      when "cdk_go"
        IAC::CdkGoAdapter.new(@lambda_spec, @config)
      when "pulumi_python"
        IAC::PulumiPythonAdapter.new(@lambda_spec, @config)
      when "pulumi_go"
        IAC::PulumiGoAdapter.new(@lambda_spec, @config)
      when "docker_desktop"
        IAC::DockerDesktopAdapter.new(@lambda_spec, @config)
      else
        raise ConfigurationError, "Unknown IAC platform: #{platform}"
      end
    end

    def create_language_support
      language = lambda_language
      
      case language
      when "ruby"
        Language::RubySupport.new(@lambda_spec, @config)
      when "rust"
        Language::RustSupport.new(@lambda_spec, @config)
      else
        raise ConfigurationError, "Unknown language: #{language}"
      end
    end

    def generate_logic_tests(test_dir)
      test_file = File.join(test_dir, "#{lambda_name}_logic_spec.rb")
      
      File.write(test_file, <<~RUBY)
        # frozen_string_literal: true

        require 'spec_helper'

        RSpec.describe '#{lambda_name} Logic' do
          describe 'handler' do
            it 'processes events correctly' do
              # TODO: Implement logic tests
              pending 'Add tests for Lambda logic'
            end
          end
        end
      RUBY
    end

    def generate_iac_tests(test_dir)
      test_file = File.join(test_dir, "#{lambda_name}_iac_spec.rb")
      
      File.write(test_file, <<~RUBY)
        # frozen_string_literal: true

        require 'spec_helper'

        RSpec.describe '#{lambda_name} IAC' do
          describe 'deployment' do
            it 'creates the Lambda function' do
              # TODO: Implement IAC tests
              pending 'Add tests for IAC deployment'
            end
          end
        end
      RUBY
    end
  end
end
