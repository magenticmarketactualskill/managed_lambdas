# frozen_string_literal: true

require "kafka"

module ManagedLambdas
  module Kafka
    class Client
      attr_reader :kafka, :config

      def initialize(config = ManagedLambdas.configuration)
        @config = config
        @kafka = ::Kafka.new(
          @config.kafka_brokers,
          client_id: @config.kafka_client_id
        )
      end

      # Publish a message to a Kafka topic
      def publish(topic, message, key: nil, partition: nil)
        OTEL::Instrumentation.trace("kafka_publish") do |span|
          span.set_attribute("messaging.system", "kafka")
          span.set_attribute("messaging.destination", topic)
          
          producer = @kafka.producer
          producer.produce(message, topic: topic, key: key, partition: partition)
          producer.deliver_messages
          
          { success: true, topic: topic }
        end
      end

      # Subscribe to a Kafka topic and process messages
      def subscribe(topic, group_id: "managed_lambdas", &block)
        OTEL::Instrumentation.trace("kafka_subscribe") do |span|
          span.set_attribute("messaging.system", "kafka")
          span.set_attribute("messaging.destination", topic)
          
          consumer = @kafka.consumer(group_id: group_id)
          consumer.subscribe(topic)
          
          consumer.each_message do |message|
            OTEL::Instrumentation.trace("kafka_process_message") do |msg_span|
              msg_span.set_attribute("messaging.message_id", message.offset)
              msg_span.set_attribute("messaging.kafka.partition", message.partition)
              
              block.call(message)
            end
          end
        end
      end

      # Subscribe to a Kafka topic and invoke a Lambda for each message
      def subscribe_and_invoke_lambda(topic, lambda_name, group_id: "managed_lambdas")
        subscribe(topic, group_id: group_id) do |message|
          # Invoke Lambda with message payload
          # This would integrate with the Lambda invocation mechanism
          invoke_lambda(lambda_name, message.value)
        end
      end

      private

      def invoke_lambda(lambda_name, payload)
        # TODO: Implement Lambda invocation
        # This would use AWS Lambda SDK or local invocation
        puts "Invoking Lambda #{lambda_name} with payload: #{payload}"
      end
    end
  end
end
