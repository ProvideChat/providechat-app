require "rails_helper"

RSpec.describe ChatMessage, type: :model do
  it { should belong_to(:chat) }
end
