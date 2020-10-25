require "rails_helper"

describe "Agent Sessions" do
  let!(:agent) { Agent.create(email: email, password: password, password_confirmation: password) }
  let(:email) { "jill@example.com" }
  let(:password) { "password" }

  before do
    visit root_path
    within(".navbar") { click_link("Sign in") }
  end

  context "failure" do
    before do
      fill_in "Email", with: email
      fill_in "Password", with: ""
      click_button "Sign in"
    end

    it "displays an error message" do
      expect(page).to have_content("Invalid email or password.")
    end

    it "shows the correct navigation links" do
      within(".navbar") do
        expect(page).to have_link("Sign in")
        expect(page).to have_link("Sign up")
        expect(page).to_not have_link("Profile")
        expect(page).to_not have_link("Sign out")
      end
    end
  end

  context "failure with unconfirmed user" do
    before do
      fill_in "Email", with: email
      fill_in "Password", with: password
      click_button "Sign in"
    end

    it "displays an error message" do
      expect(page).to have_content("You have to confirm your account before continuing")
    end

    it "shows the correct navigation links" do
      within(".navbar") do
        expect(page).to have_link("Sign in")
        expect(page).to have_link("Sign up")
        expect(page).to_not have_link("Profile")
        expect(page).to_not have_link("Sign out")
      end
    end
  end

  context "success with confirmed user" do
    before do
      user.confirm!
      fill_in "Email", with: email
      fill_in "Password", with: password
      click_button "Sign in"
    end

    it "displays a welcome message" do
      expect(page).to have_content("Signed in successfully.")
    end

    it "shows the correct navigation links" do
      within(".navbar") do
        expect(page).to have_link("Profile")
        expect(page).to have_link("Sign out")
        expect(page).to_not have_link("Sign in")
        expect(page).to_not have_link("Sign up")
      end
    end

    it "is on the negotiations index page" do
      expect(page).to have_content("Your Negotiations")
    end
  end
end
