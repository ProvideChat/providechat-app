require "spec_helper"

describe "agents/edit" do
  before(:each) do
    @agent = assign(:agent, stub_model(Agent,
      name: "MyString",
      display_name: "MyString",
      email: "MyString",
      account_type: "MyString",
      availability: "MyString",
      curr_chats: 1,
      max_chats: 1,
      active_chat_sound: "MyString",
      background_chat_sound: "MyString",
      visitor_arrived_sound: "MyString",
      avatar: "MyString",
      status: "MyString"))
  end

  it "renders the edit agent form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", agent_path(@agent), "post" do
      assert_select "input#agent_name[name=?]", "agent[name]"
      assert_select "input#agent_display_name[name=?]", "agent[display_name]"
      assert_select "input#agent_email[name=?]", "agent[email]"
      assert_select "input#agent_account_type[name=?]", "agent[account_type]"
      assert_select "input#agent_availability[name=?]", "agent[availability]"
      assert_select "input#agent_curr_chats[name=?]", "agent[curr_chats]"
      assert_select "input#agent_max_chats[name=?]", "agent[max_chats]"
      assert_select "input#agent_active_chat_sound[name=?]", "agent[active_chat_sound]"
      assert_select "input#agent_background_chat_sound[name=?]", "agent[background_chat_sound]"
      assert_select "input#agent_visitor_arrived_sound[name=?]", "agent[visitor_arrived_sound]"
      assert_select "input#agent_avatar[name=?]", "agent[avatar]"
      assert_select "input#agent_status[name=?]", "agent[status]"
    end
  end
end
