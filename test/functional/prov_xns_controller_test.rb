require 'test_helper'

class ProvXnsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prov_xns)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prov_xn" do
    assert_difference('ProvXn.count') do
      post :create, :prov_xn => { }
    end

    assert_redirected_to prov_xn_path(assigns(:prov_xn))
  end

  test "should show prov_xn" do
    get :show, :id => prov_xns(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => prov_xns(:one).to_param
    assert_response :success
  end

  test "should update prov_xn" do
    put :update, :id => prov_xns(:one).to_param, :prov_xn => { }
    assert_redirected_to prov_xn_path(assigns(:prov_xn))
  end

  test "should destroy prov_xn" do
    assert_difference('ProvXn.count', -1) do
      delete :destroy, :id => prov_xns(:one).to_param
    end

    assert_redirected_to prov_xns_path
  end
end
