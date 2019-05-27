module TestRescueAgent
  class TestRescueClient
    class TestRun
      attr_reader :id, :file_run_id, :test_id, :description, :location, :result, :failure_details, :created_at, :updated_at

      def initialize(client, attributes={})
        @client = client
        @id = attributes["id"]
        @file_run_id = attributes["file_run_id"]
        @test_id = attributes["test_id"]
        @description = attributes["description"]
        @location = attributes["location"]
        @result = attributes["result"]
        @failure_details = attributes["failure_details"]
        @created_at = attributes["created_at"]
        @updated_at = attributes["updated_at"]
      end
    end
  end
end
