require "spec_helper"

describe "agents/index" do
  before(:each) do
    assign(:agents, [
      stub_model(Agent,
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
        status: "Status"),
      stub_model(Agent,
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
        status: "Status")
    ])
  end

  it "renders a list of agents" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "Display Name".to_s, count: 2
    assert_select "tr>td", text: "Email".to_s, count: 2
    assert_select "tr>td", text: "Account Type".to_s, count: 2
    assert_select "tr>td", text: "Availability".to_s, count: 2
    assert_select "tr>td", text: 1.to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: "Active Chat Sound".to_s, count: 2
    assert_select "tr>td", text: "Background Chat Sound".to_s, count: 2
    assert_select "tr>td", text: "Visitor Arrived Sound".to_s, count: 2
    assert_select "tr>td", text: "Avatar".to_s, count: 2
    assert_select "tr>td", text: "Status".to_s, count: 2
  end
end
