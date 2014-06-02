require 'spec_helper'

describe "departments/index" do
  before(:each) do
    assign(:departments, [
      stub_model(Department,
        :organization_id => 1,
        :name => "Name",
        :email => "Email",
        :status => "Status"
      ),
      stub_model(Department,
        :organization_id => 1,
        :name => "Name",
        :email => "Email",
        :status => "Status"
      )
    ])
  end

  it "renders a list of departments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
  end
end
