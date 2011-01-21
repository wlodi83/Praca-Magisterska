require 'test_helper'

class PhotographersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:photographers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create photographer" do
    assert_difference('Photographer.count') do
      post :create, :photographer => { }
    end

    assert_redirected_to photographer_path(assigns(:photographer))
  end

  test "should show photographer" do
    get :show, :id => photographers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => photographers(:one).to_param
    assert_response :success
  end

  test "should update photographer" do
    put :update, :id => photographers(:one).to_param, :photographer => { }
    assert_redirected_to photographer_path(assigns(:photographer))
  end

  test "should destroy photographer" do
    assert_difference('Photographer.count', -1) do
      delete :destroy, :id => photographers(:one).to_param
    end

    assert_redirected_to photographers_path
  end
end
