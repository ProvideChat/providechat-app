require "rails_helper"

RSpec.describe "chats/index", type: :view do
  before(:each) do
    assign(:chats, [
      Chat.create!(
        organization_id: 1,
        website_id: 2,
        visitor_id: 3,
        operator_id: 4,
        operator_typing: "Operator Typing",
        visitor_typing: "Visitor Typing",
        visitor_name: "Visitor Name",
        visitor_email: "Visitor Email",
        visitor_department: "Visitor Department",
        visitor_question: "Visitor Question",
        status: "Status"
      ),
      Chat.create!(
        organization_id: 1,
        website_id: 2,
        visitor_id: 3,
        operator_id: 4,
        operator_typing: "Operator Typing",
        visitor_typing: "Visitor Typing",
        visitor_name: "Visitor Name",
        visitor_email: "Visitor Email",
        visitor_department: "Visitor Department",
        visitor_question: "Visitor Question",
        status: "Status"
      )
    ])
  end

  it "renders a list of chats" do
    render
    assert_select "tr>td", text: 1.to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
    assert_select "tr>td", text: 4.to_s, count: 2
    assert_select "tr>td", text: "Operator Typing".to_s, count: 2
    assert_select "tr>td", text: "Visitor Typing".to_s, count: 2
    assert_select "tr>td", text: "Visitor Name".to_s, count: 2
    assert_select "tr>td", text: "Visitor Email".to_s, count: 2
    assert_select "tr>td", text: "Visitor Department".to_s, count: 2
    assert_select "tr>td", text: "Visitor Question".to_s, count: 2
    assert_select "tr>td", text: "Status".to_s, count: 2
  end
end
