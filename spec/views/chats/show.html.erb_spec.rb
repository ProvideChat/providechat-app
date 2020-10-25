require "rails_helper"

RSpec.describe "chats/show", type: :view do
  before(:each) do
    @chat = assign(:chat, Chat.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/Operator Typing/)
    expect(rendered).to match(/Visitor Typing/)
    expect(rendered).to match(/Visitor Name/)
    expect(rendered).to match(/Visitor Email/)
    expect(rendered).to match(/Visitor Department/)
    expect(rendered).to match(/Visitor Question/)
    expect(rendered).to match(/Status/)
  end
end
