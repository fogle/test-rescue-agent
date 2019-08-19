module TestRescueAgent
  class TestRescueClient
    class FileRun
      attr_reader :id, :path, :description, :suite_run_id, :test_file_id, :created_at, :updated_at, :command

      def initialize(client, attributes={})
        @client = client
        @id = attributes["id"]
        @path = attributes["path"]
        @description = attributes["description"]
        @suite_run_id = attributes["suite_run_id"]
        @test_file_id = attributes["test_file_id"]
        @created_at = attributes["created_at"]
        @updated_at = attributes["updated_at"]
        @command = attributes["command"]
      end

      def create_test_run(attributes)
        @client.create_test_run(suite_run_id, id, attributes)
      end
    end
  end
end
