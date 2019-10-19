return unless ENV["SUITE_RUN_ID"] && ENV["TEST_RESCUE_TYPE"] == "cucumber"

require 'test_rescue_agent/test_rescue_client'
require 'cucumber'

client = TestRescueAgent::TestRescueClient.new(
  repository_id: ENV["REPOSITORY_ID"],
  endpoint: ENV["TEST_RESCUE_ENDPOINT"],
  secret: ENV["TEST_RESCUE_SECRET"],
  api_key: ENV["TEST_RESCUE_API_KEY"]
)

at_exit do
  client.complete_file_run(ENV["SUITE_RUN_ID"], ENV["FILE_RUN_ID"])
end

start = nil
Before do
  start = Time.now
end

After do |scenario|
  failure_details = nil
  if scenario.failed?
    failure_details = [
      scenario.exception.message.lines,
      scenario.exception.backtrace
    ].flatten.join("\n")
  end
  duration = Time.now - start
  client.create_test_run(
    ENV["SUITE_RUN_ID"],
    ENV["FILE_RUN_ID"],
    description: scenario.name,
    location: scenario.location.to_s,
    result: scenario.passed?,
    failure_details: failure_details,
    duration: duration
  )
end
