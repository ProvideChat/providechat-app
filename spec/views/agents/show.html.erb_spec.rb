require "spec_helper"

describe "agents/show" do
  before(:each) do
    @agent = assign(:agent, stub_model(Agent,
      name: "Name",
      display_name: "Display Name",
      email: "Email",
      account_type: "Account Type",
      availability: "Availability",
      curr_chats: 1,
      max_chats: 2,
      active_chat_sound: "Active Chat Sound",
      background_chat_sound: "Background Chat Sound",
      visitor_arrived_sound: "Visitor Arrived Sound",
      avatar: "Avatar",
      status: "Status"))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Display Name/)
    rendered.should match(/Email/)
    rendered.should match(/Account Type/)
    rendered.should match(/Availability/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/Active Chat Sound/)
    rendered.should match(/Background Chat Sound/)
    rendered.should match(/Visitor Arrived Sound/)
    rendered.should match(/Avatar/)
    rendered.should match(/Status/)
  end
end
