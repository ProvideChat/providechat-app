require "rails_helper"

describe Organization do
  it { should have_many(:agents) }
  it { should have_many(:websites) }
end
