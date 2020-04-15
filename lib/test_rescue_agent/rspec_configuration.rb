return unless ENV["SUITE_RUN_ID"] && ENV["TEST_RESCUE_TYPE"] == "rspec"

require 'test_rescue_agent/test_rescue_client'
require 'rspec'

RSpec.configure do |config|
  def test_rescue_client
    test_rescue_client = TestRescueAgent::TestRescueClient.new(
      repository_id: ENV["REPOSITORY_ID"],
      endpoint: ENV["TEST_RESCUE_ENDPOINT"],
      secret: ENV["TEST_RESCUE_SECRET"],
      api_key: ENV["TEST_RESCUE_API_KEY"]
    )
  end
  config.color = true
  config.tty = true

  module TestRescueRSpecReporter
    def notify_non_example_exception(exception, context_description)
      example = RSpec::Core::Example.new(RSpec::Core::AnonymousExampleGroup, context_description, {})
      presenter = RSpec::Core::Formatters::ExceptionPresenter.new(exception, example, indentation: 0)
      failure_details = [presenter.colorized_message_lines, presenter.colorized_formatted_backtrace].flatten.join("\n")

      test_rescue_client.create_file_run_exception(
        ENV["SUITE_RUN_ID"],
        ENV["FILE_RUN_ID"],
        description: example.full_description,
        location: example.location,
        failure_details: failure_details,
      )
      super(exception, context_description)
    end
  end

  module RSpec::Core
    class Reporter
      prepend TestRescueRSpecReporter
    end
  end

  at_exit do
    test_rescue_client.complete_file_run(ENV["SUITE_RUN_ID"], ENV["FILE_RUN_ID"])
  end

  config.after(:each) do |example|
    failure_details = nil
    if example.exception
      presenter = RSpec::Core::Formatters::ExceptionPresenter.new(example.exception, example)
      failure_details = [presenter.colorized_message_lines, presenter.colorized_formatted_backtrace].flatten.join("\n")
    end
    duration = Time.now - example.execution_result.started_at
    test_rescue_client.create_test_run(
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
