require "test_helper"

class ExampleIntegrationTest < ActionDispatch::IntegrationTest
  test "visiting home page" do
    get root_url
    assert_select "h1", "Welcome"
  end
end
