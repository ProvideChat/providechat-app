require 'rails_helper'

describe Agent do
  it { should belong_to(:organization) }
end
