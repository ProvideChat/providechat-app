require 'rails_helper'

RSpec.describe OfflineForm, :type => :model do
  it { should belong_to(:website) }
end
