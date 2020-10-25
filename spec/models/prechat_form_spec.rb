require "rails_helper"

RSpec.describe PrechatForm, type: :model do
  it { should belong_to(:organization) }
  it { should belong_to(:website) }
end
