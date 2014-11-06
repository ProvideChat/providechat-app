require 'rails_helper'

RSpec.describe Website, :type => :model do
  it { should belong_to(:organization) }
end
