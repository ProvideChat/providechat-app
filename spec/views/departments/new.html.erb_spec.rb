require "spec_helper"

describe "departments/new" do
  before(:each) do
    assign(:department, stub_model(Department,
      organization_id: 1,
      name: "MyString",
      email: "MyString",
      status: "MyString").as_new_record)
  end

  it "renders new department form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", departments_path, "post" do
      assert_select "input#department_organization_id[name=?]", "department[organization_id]"
      assert_select "input#department_name[name=?]", "department[name]"
      assert_select "input#department_email[name=?]", "department[email]"
      assert_select "input#department_status[name=?]", "department[status]"
    end
  end
end
