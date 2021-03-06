require "rails_helper"

RSpec.describe "websites/new", type: :view do
  before(:each) do
    assign(:website, Website.new(
      organization_id: 1,
      url: "MyString",
      name: "MyString",
      default_department: 1,
      logo: "MyString",
      status: "MyString"
    ))
  end

  it "renders new website form" do
    render

    assert_select "form[action=?][method=?]", websites_path, "post" do
      assert_select "input#website_organization_id[name=?]", "website[organization_id]"

      assert_select "input#website_url[name=?]", "website[url]"

      assert_select "input#website_name[name=?]", "website[name]"

      assert_select "input#website_default_department[name=?]", "website[default_department]"

      assert_select "input#website_logo[name=?]", "website[logo]"

      assert_select "input#website_status[name=?]", "website[status]"
    end
  end
end
