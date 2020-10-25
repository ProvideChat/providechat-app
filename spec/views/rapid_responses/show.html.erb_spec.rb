require "rails_helper"

RSpec.describe "rapid_responses/show", type: :view do
  before(:each) do
    @rapid_response = assign(:rapid_response, RapidResponse.create!(
      organization_id: 1,
      name: "Name",
      text: "Text",
      order: 2,
      ancestry: "Ancestry",
      status: "Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Text/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Ancestry/)
    expect(rendered).to match(/Status/)
  end
end
