require 'rails_helper'

RSpec.describe Agent do
  it { should belong_to(:organization) }
end
