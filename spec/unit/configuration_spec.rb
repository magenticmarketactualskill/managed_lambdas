# frozen_string_literal: true

require "spec_helper"

RSpec.describe ManagedLambdas::Configuration do
  describe "#initialize" do
    it "sets default values" do
      config = described_class.new
      
      expect(config.data_shapes_url).to eq("http://localhost:3000/data_shapes/api/v1")
      expect(config.otel_exporter).to eq("console")
      expect(config.kafka_brokers).to eq(["localhost:9092"])
      expect(config.default_iac_platform).to eq("cloudformation")
      expect(config.default_language).to eq("ruby")
      expect(config.aws_region).to eq("us-east-1")
    end

    it "reads values from environment variables" do
      ENV["DATA_SHAPES_URL"] = "http://example.com/api"
      ENV["AWS_REGION"] = "us-west-2"
      
      config = described_class.new
      
      expect(config.data_shapes_url).to eq("http://example.com/api")
      expect(config.aws_region).to eq("us-west-2")
      
      # Clean up
      ENV.delete("DATA_SHAPES_URL")
      ENV.delete("AWS_REGION")
    end
  end

  describe "#validate!" do
    it "raises error when data_shapes_url is blank" do
      config = described_class.new
      config.data_shapes_url = ""
      
      expect { config.validate! }.to raise_error(ManagedLambdas::ConfigurationError)
    end

    it "raises error when kafka_brokers is empty" do
      config = described_class.new
      config.kafka_brokers = []
      
      expect { config.validate! }.to raise_error(ManagedLambdas::ConfigurationError)
    end

    it "does not raise error when all required fields are present" do
      config = described_class.new
      
      expect { config.validate! }.not_to raise_error
    end
  end
end
