require 'rails_helper'

RSpec.describe "rapid_responses/new", :type => :view do
  before(:each) do
    assign(:rapid_response, RapidResponse.new(
      :organization_id => 1,
      :name => "MyString",
      :text => "MyString",
      :order => 1,
      :ancestry => "MyString",
      :status => "MyString"
    ))
  end

  it "renders new rapid_response form" do
    render

    assert_select "form[action=?][method=?]", rapid_responses_path, "post" do

      assert_select "input#rapid_response_organization_id[name=?]", "rapid_response[organization_id]"

      assert_select "input#rapid_response_name[name=?]", "rapid_response[name]"

      assert_select "input#rapid_response_text[name=?]", "rapid_response[text]"

      assert_select "input#rapid_response_order[name=?]", "rapid_response[order]"

      assert_select "input#rapid_response_ancestry[name=?]", "rapid_response[ancestry]"

      assert_select "input#rapid_response_status[name=?]", "rapid_response[status]"
    end
  end
end
