# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
require "simplecov"

# Start SimpleCov for coverage reporting
SimpleCov.start "rails" do
  minimum_coverage 0
end

# Use pretty Minitest output
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class ActiveSupport::TestCase
  # Run tests in parallel using processors
  parallelize(workers: :number_of_processors)

  # Setup all fixtures if you want to use them
  # fixtures :all

  # Add helper methods here
end
