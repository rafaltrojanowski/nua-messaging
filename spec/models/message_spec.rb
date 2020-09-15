require 'rails_helper'

RSpec.describe Message, type: :model do
  it { should validate_presence_of(:body).
    with_message(/can't be blank/) }
  
  describe '#after_create' do
    it 'increments unread_messages_count in inbox' do
      message = FactoryBot.build(:message)
      message.save!

      expect(message.inbox.unread_messages_count).to eq(1)
    end
  end

  describe '#after_save' do
    let!(:message) { FactoryBot.create(:message) }
    let(:inbox) { message.inbox }

    it 'decrements unread_messages_count in inbox if read has changed' do
      expect(inbox.unread_messages_count).to eq(1)
      message.update!(read: true)
      expect(inbox.unread_messages_count).to eq(0)
    end
  end
end
