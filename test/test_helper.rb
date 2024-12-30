ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers
  include Warden::Test::Helpers

  parallelize(workers: :number_of_processors, with: :threads)
  fixtures :all

  def setup
    Warden.test_mode!
  end

  def teardown
    Warden.test_reset!
  end
end