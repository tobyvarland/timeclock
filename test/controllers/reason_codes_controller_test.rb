require 'test_helper'

class ReasonCodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reason_code = reason_codes(:one)
  end

  test "should get index" do
    get reason_codes_url
    assert_response :success
  end

  test "should get new" do
    get new_reason_code_url
    assert_response :success
  end

  test "should create reason_code" do
    assert_difference('ReasonCode.count') do
      post reason_codes_url, params: { reason_code: { code: @reason_code.code, requires_notes: @reason_code.requires_notes } }
    end

    assert_redirected_to reason_code_url(ReasonCode.last)
  end

  test "should show reason_code" do
    get reason_code_url(@reason_code)
    assert_response :success
  end

  test "should get edit" do
    get edit_reason_code_url(@reason_code)
    assert_response :success
  end

  test "should update reason_code" do
    patch reason_code_url(@reason_code), params: { reason_code: { code: @reason_code.code, requires_notes: @reason_code.requires_notes } }
    assert_redirected_to reason_code_url(@reason_code)
  end

  test "should destroy reason_code" do
    assert_difference('ReasonCode.count', -1) do
      delete reason_code_url(@reason_code)
    end

    assert_redirected_to reason_codes_url
  end
end
