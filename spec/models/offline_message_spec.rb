require "rails_helper"

RSpec.describe OfflineMessage, type: :model do
  it { should belong_to(:organization) }
end
