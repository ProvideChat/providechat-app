require 'rails_helper'

RSpec.describe Visitor, :type => :model do
  it { should belong_to(:website) }

  it "should titlize the name upon save" do
    visitor = Visitor.new
    visitor.name = 'henry rollins'
    visitor.save

    expect(visitor.name).to eq 'Henry Rollins'
  end
end
