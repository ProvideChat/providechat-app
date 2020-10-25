require "spec_helper"

describe "departments/edit" do
  before(:each) do
    @department = assign(:department, stub_model(Department,
      organization_id: 1,
      name: "MyString",
      email: "MyString",
      status: "MyString"))
  end

  it "renders the edit department form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", department_path(@department), "post" do
      assert_select "input#department_organization_id[name=?]", "department[organization_id]"
      assert_select "input#department_name[name=?]", "department[name]"
      assert_select "input#department_email[name=?]", "department[email]"
      assert_select "input#department_status[name=?]", "department[status]"
    end
  end
end
