require "spec_helper"

describe "organizations/index" do
  before(:each) do
    assign(:organizations, [
      stub_model(Organization,
        name: "Name",
        email: "Email",
        widget_installed: "Widget Installed",
        default_department: 1,
        edition: "Edition",
        payment_system: "Payment System"),
      stub_model(Organization,
        name: "Name",
        email: "Email",
        widget_installed: "Widget Installed",
        default_department: 1,
        edition: "Edition",
        payment_system: "Payment System")
    ])
  end

  it "renders a list of organizations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "Email".to_s, count: 2
    assert_select "tr>td", text: "Widget Installed".to_s, count: 2
    assert_select "tr>td", text: 1.to_s, count: 2
    assert_select "tr>td", text: "Edition".to_s, count: 2
    assert_select "tr>td", text: "Payment System".to_s, count: 2
  end
end
