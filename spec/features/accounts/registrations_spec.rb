require 'rails_helper'

describe "User Registration" do
  before do
    visit root_path
    within('.navbar') { click_link('Sign up') }
  end

  context "failure" do
    before do
      fill_in 'Email', with: ''
      click_button 'Sign up'
    end

    it "displays an error message" do
      expect(page).to have_content("Please review the problems below")
    end

    it "shows the correct navigation links" do
      within('.navbar') do
        expect(page).to have_link('Sign in')
        expect(page).to have_link('Sign up')
        expect(page).to_not have_link('Profile')
        expect(page).to_not have_link('Sign out')
      end
    end
  end

  context "success" do
    before do
      fill_in 'Email', with: 'jill@example.com'
      click_button 'Sign up'
    end

    it "displays a confirmation message" do
      expect(page).to have_content("A message with a confirmation link has been sent to your email address")
    end

    it "delivers the confirmation email" do
      open_email('jill@example.com')
      current_email.should have_content 'You can confirm your account email through the link below'
      current_email.click_link "Confirm my account"
      expect(page).to have_content('Your account was successfully confirmed')

      fill_in 'Email', with: 'jill@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Sign in'
      expect(page).to have_content('Signed in successfully.')
    end
  end
end