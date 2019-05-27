module TestRescueAgent
  class TestRescueClient
    class SuiteRun
      attr_reader :id, :repository_id, :created_at, :updated_at

      def initialize(client, attributes={})
        @client = client
        @id = attributes["id"]
        @repository_id = attributes["repository_id"]
        @created_at = attributes["created_at"]
        @updated_at = attributes["updated_at"]
      end

      def create_file_run(attributes)
        @client.create_file_run(id, attributes)
      end
    end
  end
end
