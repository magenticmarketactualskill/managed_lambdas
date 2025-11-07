# frozen_string_literal: true

module ManagedLambdas
  class Core
    attr_reader :config, :data_shapes_client

    def initialize(config = ManagedLambdas.configuration)
      @config = config || Configuration.new
      @config.validate!
      @data_shapes_client = DataShapes::Client.new(@config.data_shapes_url)
    end

    # Create a new Lambda specification
    def create_specification(spec_details)
      OTEL::Instrumentation.trace("create_specification") do
        shacl_definition = build_shacl_definition(spec_details)
        
        response = @data_shapes_client.create_data_shape(
          name: spec_details[:name],
          description: spec_details[:description],
          shacl_definition: shacl_definition
        )

        if response.success?
          response.body
        else
          raise SpecificationError, "Failed to create specification: #{response.body}"
        end
      end
    end

    # Get an existing Lambda specification
    def get_specification(spec_name)
      OTEL::Instrumentation.trace("get_specification") do
        response = @data_shapes_client.get_data_shape_by_name(spec_name)
        
        if response.success?
          response.body
        else
          raise SpecificationError, "Failed to get specification: #{response.body}"
        end
      end
    end

    # Deploy a Lambda based on its specification
    def deploy(spec_name, iac_platform: nil)
      OTEL::Instrumentation.trace("deploy") do
        spec = get_specification(spec_name)
        lifecycle_manager = LifecycleManager.new(spec, iac_platform: iac_platform)
        lifecycle_manager.deploy
      end
    end

    # Detect if a Lambda exists in the IAC platform
    def detect(spec_name, iac_platform: nil)
      OTEL::Instrumentation.trace("detect") do
        spec = get_specification(spec_name)
        lifecycle_manager = LifecycleManager.new(spec, iac_platform: iac_platform)
        lifecycle_manager.detect
      end
    end

    # Manage a Lambda (enable, disable, get_status)
    def manage(spec_name, action, iac_platform: nil)
      OTEL::Instrumentation.trace("manage") do
        spec = get_specification(spec_name)
        lifecycle_manager = LifecycleManager.new(spec, iac_platform: iac_platform)
        lifecycle_manager.manage(action)
      end
    end

    # Generate tests for a Lambda
    def generate_tests(spec_name)
      OTEL::Instrumentation.trace("generate_tests") do
        spec = get_specification(spec_name)
        lifecycle_manager = LifecycleManager.new(spec)
        lifecycle_manager.generate_tests
      end
    end

    # Run tests for a Lambda
    def run_tests(spec_name)
      OTEL::Instrumentation.trace("run_tests") do
        spec = get_specification(spec_name)
        lifecycle_manager = LifecycleManager.new(spec)
        lifecycle_manager.run_tests
      end
    end

    private

    def build_shacl_definition(spec_details)
      # Build SHACL definition from spec_details
      # This is a simplified example
      <<~SHACL
        @prefix sh: <http://www.w3.org/ns/shacl#> .
        @prefix ml: <http://managed-lambdas.org/> .
        @prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

        ml:#{spec_details[:name]}Shape
          a sh:NodeShape ;
          sh:targetClass ml:Lambda ;
          sh:property [
            sh:path ml:name ;
            sh:datatype xsd:string ;
            sh:minCount 1 ;
            sh:maxCount 1 ;
          ] ;
          sh:property [
            sh:path ml:language ;
            sh:datatype xsd:string ;
            sh:in ("ruby" "rust") ;
          ] ;
          sh:property [
            sh:path ml:iacPlatform ;
            sh:datatype xsd:string ;
            sh:in ("cloudformation" "cdk_python" "cdk_go" "pulumi_python" "pulumi_go" "docker_desktop") ;
          ] .
      SHACL
    end
  end
end
