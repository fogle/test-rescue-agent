Gem::Specification.new do |s|
  s.name = "test-rescue-agent"
  s.version = '0.1.0'
  s.required_ruby_version = '>= 2.0.0'
  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = [ "Ryan Fogle", "Greg Pattison"]
  s.date = Time.now.strftime('%Y-%m-%d')
  s.licenses    = ['MIT']
  s.description = <<-EOS
Test Rescue is a massively parallelized continuous testing platform,
(http://www.testrescue.com). Test Rescue provides you with large scale
Test automation execution performance by parallelizing each individual
test in its own container automatically provisioned and run in the cloud.
Results are provided live as your tests complete.
Test Rescue provides you with deep information about the performance
of your test suite as it runs. The Test Rescue Agent is a Gem, hosted on
https://github.com/fogle/test-rescue-adapter/
EOS
  s.email = "support@testrescue.com"
  s.files = Dir.glob('lib/**/*.rb')
  s.add_dependency "rspec"
  s.add_dependency "httparty"
  s.executables << 'test-rescue'

  s.homepage = "https://github.com/fogle/test-rescue-agent"
  s.require_paths = ["lib"]
  s.rubygems_version = Gem::VERSION
  s.summary = "Test Rescue Ruby Agent"
end
