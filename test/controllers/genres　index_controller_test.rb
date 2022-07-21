require "test_helper"

class Genres　indexControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get genres　index_edit_url
    assert_response :success
  end
end
