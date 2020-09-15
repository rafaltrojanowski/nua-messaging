require 'rails_helper'

RSpec.describe Message, type: :model do
  it { should validate_presence_of(:body).
    with_message(/can't be blank/) }
end
