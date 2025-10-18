# test/integration/example_integration_test.rb
class ExampleIntegrationTest < ActionDispatch::IntegrationTest
  test "visiting home page" do
    get root_url
    assert_select "h1", "Home#index"  # oppure "Welcome" se modifichi la view
  end
end
