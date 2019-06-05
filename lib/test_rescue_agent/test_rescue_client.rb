require 'test_rescue_agent/test_rescue_client/suite_run'
require 'test_rescue_agent/test_rescue_client/file_run'
require 'test_rescue_agent/test_rescue_client/test_run'

module TestRescueAgent
  class TestRescueClient
    def initialize(options={})
      @endpoint = options[:endpoint]
      @repository_id = options[:repository_id]
      @api_key = options[:api_key]
      @secret = options[:secret]
    end

    def create_suite_run
      response = post('/suite_runs', suite_run: {
        head_branch: 'master',
        head_sha: 'foo',
        title: 'Collect Pull Request Title from GitHub'
      })
      TestRescueClient::SuiteRun.new(self, JSON.parse(response.body))
    end

    def create_file_run(suite_run_id, attributes)
      response = post("/suite_runs/#{suite_run_id}/file_runs", file_run: attributes)
      TestRescueClient::FileRun.new(self, JSON.parse(response.body))
    end

    def complete_file_run(suite_run_id, file_run_id)
      update_file_run(suite_run_id, file_run_id, {completed_at: Time.now.iso8601})
    end

    def update_file_run(suite_run_id, file_run_id, attributes)
      response = patch("/suite_runs/#{suite_run_id}/file_runs/#{file_run_id}", file_run: attributes)
    end

    def create_test_run(suite_run_id, file_run_id, attributes)
      response = post("/suite_runs/#{suite_run_id}/file_runs/#{file_run_id}/test_runs", test_run: attributes)
      TestRescueClient::TestRun.new(self, JSON.parse(response.body))
    end

    private

    def headers
      {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'X-Api-Key' => @api_key,
        'X-Api-Secret' => @secret
      }
    end

    def post(path, body)
      url = "#{@endpoint}/repositories/#{@repository_id}#{path}"
      HTTParty.post(url, body: body.to_json, headers: headers)
    end

    def patch(path, body)
      url = "#{@endpoint}/repositories/#{@repository_id}#{path}"
      HTTParty.patch(url, body: body.to_json, headers: headers)
    end
  end
end
