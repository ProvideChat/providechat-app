require "rails_helper"

RSpec.describe "websites/show", type: :view do
  before(:each) do
    @website = assign(:website, Website.create!(
      organization_id: 1,
      url: "Url",
      name: "Name",
      default_department: 2,
      logo: "Logo",
      status: "Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Url/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Logo/)
    expect(rendered).to match(/Status/)
  end
end
