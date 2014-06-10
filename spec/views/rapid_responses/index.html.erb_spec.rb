require 'rails_helper'

RSpec.describe "rapid_responses/index", :type => :view do
  before(:each) do
    assign(:rapid_responses, [
      RapidResponse.create!(
        :organization_id => 1,
        :name => "Name",
        :text => "Text",
        :order => 2,
        :ancestry => "Ancestry",
        :status => "Status"
      ),
      RapidResponse.create!(
        :organization_id => 1,
        :name => "Name",
        :text => "Text",
        :order => 2,
        :ancestry => "Ancestry",
        :status => "Status"
      )
    ])
  end

  it "renders a list of rapid_responses" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Text".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Ancestry".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
  end
end
