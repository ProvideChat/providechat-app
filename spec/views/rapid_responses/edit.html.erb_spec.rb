require 'rails_helper'

RSpec.describe "rapid_responses/edit", :type => :view do
  before(:each) do
    @rapid_response = assign(:rapid_response, RapidResponse.create!(
      :organization_id => 1,
      :name => "MyString",
      :text => "MyString",
      :order => 1,
      :ancestry => "MyString",
      :status => "MyString"
    ))
  end

  it "renders the edit rapid_response form" do
    render

    assert_select "form[action=?][method=?]", rapid_response_path(@rapid_response), "post" do

      assert_select "input#rapid_response_organization_id[name=?]", "rapid_response[organization_id]"

      assert_select "input#rapid_response_name[name=?]", "rapid_response[name]"

      assert_select "input#rapid_response_text[name=?]", "rapid_response[text]"

      assert_select "input#rapid_response_order[name=?]", "rapid_response[order]"

      assert_select "input#rapid_response_ancestry[name=?]", "rapid_response[ancestry]"

      assert_select "input#rapid_response_status[name=?]", "rapid_response[status]"
    end
  end
end
