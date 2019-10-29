require "application_system_test_case"

class PunchesTest < ApplicationSystemTestCase
  setup do
    @punch = punches(:one)
  end

  test "visiting the index" do
    visit punches_url
    assert_selector "h1", text: "Punches"
  end

  test "creating a Punch" do
    visit punches_url
    click_on "New Punch"

    fill_in "Punch at", with: @punch.punch_at
    fill_in "Punch type", with: @punch.punch_type
    fill_in "User", with: @punch.user_id
    click_on "Create Punch"

    assert_text "Punch was successfully created"
    click_on "Back"
  end

  test "updating a Punch" do
    visit punches_url
    click_on "Edit", match: :first

    fill_in "Punch at", with: @punch.punch_at
    fill_in "Punch type", with: @punch.punch_type
    fill_in "User", with: @punch.user_id
    click_on "Update Punch"

    assert_text "Punch was successfully updated"
    click_on "Back"
  end

  test "destroying a Punch" do
    visit punches_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Punch was successfully destroyed"
  end
end
