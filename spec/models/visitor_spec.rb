require 'rails_helper'

RSpec.describe Visitor, :type => :model do
  it { should belong_to(:website) }
end
