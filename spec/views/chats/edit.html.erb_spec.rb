require 'rails_helper'

RSpec.describe "chats/edit", :type => :view do
  before(:each) do
    @chat = assign(:chat, Chat.create!(
      :organization_id => 1,
      :website_id => 1,
      :visitor_id => 1,
      :operator_id => 1,
      :operator_typing => "MyString",
      :visitor_typing => "MyString",
      :visitor_name => "MyString",
      :visitor_email => "MyString",
      :visitor_department => "MyString",
      :visitor_question => "MyString",
      :status => "MyString"
    ))
  end

  it "renders the edit chat form" do
    render

    assert_select "form[action=?][method=?]", chat_path(@chat), "post" do

      assert_select "input#chat_organization_id[name=?]", "chat[organization_id]"

      assert_select "input#chat_website_id[name=?]", "chat[website_id]"

      assert_select "input#chat_visitor_id[name=?]", "chat[visitor_id]"

      assert_select "input#chat_operator_id[name=?]", "chat[operator_id]"

      assert_select "input#chat_operator_typing[name=?]", "chat[operator_typing]"

      assert_select "input#chat_visitor_typing[name=?]", "chat[visitor_typing]"

      assert_select "input#chat_visitor_name[name=?]", "chat[visitor_name]"

      assert_select "input#chat_visitor_email[name=?]", "chat[visitor_email]"

      assert_select "input#chat_visitor_department[name=?]", "chat[visitor_department]"

      assert_select "input#chat_visitor_question[name=?]", "chat[visitor_question]"

      assert_select "input#chat_status[name=?]", "chat[status]"
    end
  end
end
