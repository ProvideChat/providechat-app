require 'spec_helper'

describe "organizations/show" do
  before(:each) do
    @organization = assign(:organization, stub_model(Organization,
      :name => "Name",
      :email => "Email",
      :widget_installed => "Widget Installed",
      :default_department => 1,
      :edition => "Edition",
      :payment_system => "Payment System"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Email/)
    rendered.should match(/Widget Installed/)
    rendered.should match(/1/)
    rendered.should match(/Edition/)
    rendered.should match(/Payment System/)
  end
end
