require "rails_helper"

describe "Agent Authentication" do
  subject { page }

  describe "for non-signed-in agents" do
    let(:agent) { FactoryBot.create(:agent) }

    describe "when attempting to visit" do
      describe "the edit page" do
        before { visit edit_agent_path(agent) }
        it { should have_title("Sign in") }
        it { should have_content("You need to sign in or sign up before continuing.") }
      end

      describe "the negotiations page" do
        before { visit negotiations_path }
        it { should have_title("Sign in") }
        it { should have_content("You need to sign in or sign up before continuing.") }
      end
    end
  end

  describe "for signed-in agents" do
    let(:agent) { FactoryBot.create(:agent) }
    before { sign_in agent }

    describe "when attempting to visit" do
      describe "the edit page" do
        before { visit edit_agent_path(agent) }
        it { should have_title("Your Profile") }
        it { should have_xpath("//input[@value='#{user.email}']") }
      end

      describe "the negotiations page" do
        before { visit negotiations_path }
        it { should have_title("Your Negotiations") }
        it { should have_content("Your Negotiations") }
      end
    end
  end
end
