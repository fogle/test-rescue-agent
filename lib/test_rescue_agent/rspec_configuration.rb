require 'test_rescue_agent/test_rescue_client'

RSpec.configure do |config|
  next unless ENV["SUITE_RUN_ID"]

  client = nil

  config.before(:suite) do
    client = TestRescueClient.new(
      repository_id: ENV["REPOSITORY_ID"],
      endpoint: ENV["TEST_RESCUE_ENDPOINT"],
      secret: ENV["TEST_RESCUE_SECRET"],
      api_key: ENV["TEST_RESCUE_API_KEY"]
    )
  end

  config.after(:suite) do |example|
    client.complete_file_run(ENV["SUITE_RUN_ID"], ENV["FILE_RUN_ID"])
  end

  config.after(:each) do |example|
    failure_details = nil
    if example.exception
      presenter = RSpec::Core::Formatters::ExceptionPresenter.new(example.exception, example)
      failure_details = [presenter.colorized_message_lines, presenter.colorized_formatted_backtrace].flatten.join("\n")
    end
    duration = Time.now - example.execution_result.started_at
    client.create_test_run(
      ENV["SUITE_RUN_ID"],
      ENV["FILE_RUN_ID"],
      description: example.full_description,
      location: example.location,
      result: !example.exception,
      failure_details: failure_details,
      duration: duration
    )
  end
end
