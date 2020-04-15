module TestRescueAgent
  class TestRescueClient
    class FileRunException
      attr_reader :id, :suite_run_id, :file_run_id, :description, :location, :failure_details

      def initialize(client, attributes={})
        @client = client
        @id = attributes["id"]
        @suite_run_id = attributes["suite_run_id"]
        @file_run_id = attributes["file_run_id"]
        @description = attributes["description"]
        @location = attributes["location"]
        @failure_details = attributes["failure_details"]
      end
    end
  end
end
