require "application_system_test_case"

class ReasonCodesTest < ApplicationSystemTestCase
  setup do
    @reason_code = reason_codes(:one)
  end

  test "visiting the index" do
    visit reason_codes_url
    assert_selector "h1", text: "Reason Codes"
  end

  test "creating a Reason code" do
    visit reason_codes_url
    click_on "New Reason Code"

    fill_in "Code", with: @reason_code.code
    check "Requires notes" if @reason_code.requires_notes
    click_on "Create Reason code"

    assert_text "Reason code was successfully created"
    click_on "Back"
  end

  test "updating a Reason code" do
    visit reason_codes_url
    click_on "Edit", match: :first

    fill_in "Code", with: @reason_code.code
    check "Requires notes" if @reason_code.requires_notes
    click_on "Update Reason code"

    assert_text "Reason code was successfully updated"
    click_on "Back"
  end

  test "destroying a Reason code" do
    visit reason_codes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Reason code was successfully destroyed"
  end
end
