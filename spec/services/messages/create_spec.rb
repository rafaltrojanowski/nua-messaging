require 'rails_helper'

RSpec.describe Messages::Create, type: :service do

  subject { described_class.new }

  let!(:patient) { FactoryBot.create(:user, is_patient: true) }
  let!(:doctor) { FactoryBot.create(:user, is_doctor: true) }

  let!(:patient_outbox) { FactoryBot.create(:outbox, user: patient) }
  let!(:doctor_inbox) { FactoryBot.create(:inbox, user: doctor) }

  context 'when only params passed in' do
    let(:service_call) { subject.call(attrs: params) }

    context 'when object is valid' do
      let(:params) {{ body: 'Lorem ipsum' }}

      it 'saves object to database' do
        expect(service_call.message.body).to eq(params[:body])
        expect(service_call.message.persisted?).to be_truthy
        expect(service_call.errors).to be_empty
      end
    end

    context 'when object is not valid' do
      let(:params) {{ body: '' }}

      it 'returns errors' do
        expect(service_call.errors.to_h).to eq(
          body: "can't be blank"
        )
        expect(service_call.message.persisted?).to be_falsey
      end
    end
  end

  context 'when original_message_id passed in with params' do
    let(:params) {{ body: 'Lorem ipsum' }}

    let(:new_original_message) { FactoryBot.create(:message, created_at: 1.day.ago) }
    let(:old_original_message) { FactoryBot.create(:message, created_at: 8.days.ago) }

    let(:new_original_message_id) { new_original_message.id }
    let(:old_original_message_id) { old_original_message.id }

    let!(:admin) { FactoryBot.create(:user, is_admin: true) }
    let!(:admin_inbox) { FactoryBot.create(:inbox, user: admin) }

    context 'and when the original message was created in the past week' do
      let(:service_call) { subject.call(
        attrs: params, 
        original_message_id: new_original_message_id
      )}

      it 'it should be routed to doctor' do
        expect(service_call.message.inbox.user).to eq(doctor)
      end
    end

    context 'and when the original message was created more than a week ago' do
      let(:service_call) { subject.call(
        attrs: params, 
        original_message_id: old_original_message_id
      )}

      it 'it should be routed to admin' do
        expect(service_call.message.inbox.user).to eq(admin)
      end
    end
  end
end
