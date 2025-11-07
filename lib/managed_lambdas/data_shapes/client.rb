# frozen_string_literal: true

require "faraday"
require "json"

module ManagedLambdas
  module DataShapes
    class Client
      attr_reader :base_url, :connection

      def initialize(base_url)
        @base_url = base_url
        @connection = Faraday.new(url: base_url) do |faraday|
          faraday.request :json
          faraday.response :json, content_type: /\bjson$/
          faraday.adapter Faraday.default_adapter
        end
      end

      # Get a data shape by ID
      def get_data_shape(id)
        connection.get("data_shapes/#{id}")
      end

      # Get a data shape by name
      def get_data_shape_by_name(name)
        response = connection.get("data_shapes") do |req|
          req.params["name"] = name
        end
        
        if response.success? && response.body["data_shapes"]&.any?
          response.body["data_shapes"].first
        else
          response
        end
      end

      # Create a new data shape
      def create_data_shape(data_shape_params)
        connection.post("data_shapes", { data_shape: data_shape_params })
      end

      # Update an existing data shape
      def update_data_shape(id, data_shape_params)
        connection.put("data_shapes/#{id}", { data_shape: data_shape_params })
      end

      # Delete a data shape
      def delete_data_shape(id)
        connection.delete("data_shapes/#{id}")
      end

      # Validate data against a data shape
      def validate_data(id, data_graph)
        connection.post("data_shapes/#{id}/validate", { data_graph: data_graph })
      end

      # Get children of a data shape
      def get_children(id)
        connection.get("data_shapes/#{id}/children")
      end

      # Get ancestors of a data shape
      def get_ancestors(id)
        connection.get("data_shapes/#{id}/ancestors")
      end

      # Get descendants of a data shape
      def get_descendants(id)
        connection.get("data_shapes/#{id}/descendants")
      end

      # Version management
      def get_versions(data_shape_id)
        connection.get("data_shapes/#{data_shape_id}/versions")
      end

      def create_version(data_shape_id, version_params)
        connection.post("data_shapes/#{data_shape_id}/versions", { version: version_params })
      end

      def get_version(version_id)
        connection.get("versions/#{version_id}")
      end

      def validate_version(version_id, data_graph)
        connection.post("versions/#{version_id}/validate", { data_graph: data_graph })
      end
    end
  end
end
