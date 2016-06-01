require 'test_helper'

class CrawsControllerTest < ActionController::TestCase
  setup do
    @craw = craws(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:craws)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create craw" do
    assert_difference('Craw.count') do
      post :create, craw: {  }
    end

    assert_redirected_to craw_path(assigns(:craw))
  end

  test "should show craw" do
    get :show, id: @craw
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @craw
    assert_response :success
  end

  test "should update craw" do
    patch :update, id: @craw, craw: {  }
    assert_redirected_to craw_path(assigns(:craw))
  end

  test "should destroy craw" do
    assert_difference('Craw.count', -1) do
      delete :destroy, id: @craw
    end

    assert_redirected_to craws_path
  end
end
