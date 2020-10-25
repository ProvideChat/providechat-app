require "spec_helper"

describe "organizations/new" do
  before(:each) do
    assign(:organization, stub_model(Organization,
      name: "MyString",
      email: "MyString",
      widget_installed: "MyString",
      default_department: 1,
      edition: "MyString",
      payment_system: "MyString").as_new_record)
  end

  it "renders new organization form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", organizations_path, "post" do
      assert_select "input#organization_name[name=?]", "organization[name]"
      assert_select "input#organization_email[name=?]", "organization[email]"
      assert_select "input#organization_widget_installed[name=?]", "organization[widget_installed]"
      assert_select "input#organization_default_department[name=?]", "organization[default_department]"
      assert_select "input#organization_edition[name=?]", "organization[edition]"
      assert_select "input#organization_payment_system[name=?]", "organization[payment_system]"
    end
  end
end
