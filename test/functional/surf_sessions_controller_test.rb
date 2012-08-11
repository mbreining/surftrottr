require 'test_helper'

class SurfSessionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:surf_sessions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create surf_session" do
    assert_difference('SurfSession.count') do
      post :create, :surf_session => { }
    end

    assert_redirected_to surf_session_path(assigns(:surf_session))
  end

  test "should show surf_session" do
    get :show, :id => surf_sessions(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => surf_sessions(:one).to_param
    assert_response :success
  end

  test "should update surf_session" do
    put :update, :id => surf_sessions(:one).to_param, :surf_session => { }
    assert_redirected_to surf_session_path(assigns(:surf_session))
  end

  test "should destroy surf_session" do
    assert_difference('SurfSession.count', -1) do
      delete :destroy, :id => surf_sessions(:one).to_param
    end

    assert_redirected_to surf_sessions_path
  end
end
