require "rails_helper"

RSpec.describe RapidResponse, type: :model do
  it { should belong_to(:website) }
end
