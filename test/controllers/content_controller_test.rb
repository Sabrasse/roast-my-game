require "test_helper"

class ContentControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get content_new_url
    assert_response :success
  end
end
