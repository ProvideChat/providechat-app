require 'rails_helper'

describe Department do
  it { should belong_to(:organization) }
end
