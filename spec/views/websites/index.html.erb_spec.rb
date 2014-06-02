require 'rails_helper'

RSpec.describe "websites/index", :type => :view do
  before(:each) do
    assign(:websites, [
      Website.create!(
        :organization_id => 1,
        :url => "Url",
        :name => "Name",
        :default_department => 2,
        :logo => "Logo",
        :status => "Status"
      ),
      Website.create!(
        :organization_id => 1,
        :url => "Url",
        :name => "Name",
        :default_department => 2,
        :logo => "Logo",
        :status => "Status"
      )
    ])
  end

  it "renders a list of websites" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Logo".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
  end
end
