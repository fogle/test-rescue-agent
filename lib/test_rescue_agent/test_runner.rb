require 'test_rescue_agent/test_rescue_client'

module TestRescueAgent
  class TestRunner
    def self.run
      client = TestRescueAgent::TestRescueClient.new(
        repository_id: ENV["REPOSITORY_ID"],
        endpoint: ENV["TEST_RESCUE_ENDPOINT"],
        secret: ENV["TEST_RESCUE_SECRET"],
        api_key: ENV["TEST_RESCUE_API_KEY"]
      )
      while file_run = client.claim_file_run(ENV["SUITE_RUN_ID"], ENV["CONTAINER_ID"])
        puts "running \"#{file_run.command}\""
        `#{file_run.command}`
      end
    end
  end
end
