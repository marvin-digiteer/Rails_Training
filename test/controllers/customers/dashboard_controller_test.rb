require "test_helper"

class Customers::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get customers_dashboard_index_url
    assert_response :success
  end
end
