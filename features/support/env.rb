# frozen_string_literal: true

require "bundler/setup"
require "managed_lambdas"
require "webmock/cucumber"

# Configure WebMock to allow localhost connections
WebMock.disable_net_connect!(allow_localhost: true)

# Reset configuration before each scenario
Before do
  ManagedLambdas.reset_configuration!
end
