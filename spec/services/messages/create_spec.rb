require 'rails_helper'

RSpec.describe Messages::Create, type: :service do

  subject { described_class.new }
  let(:service_call) { subject.call(params) }

  before do
    patient = FactoryBot.create(:user, is_patient: true)
    doctor = FactoryBot.create(:user, is_doctor: true)
    FactoryBot.create(:outbox, user: patient)
    FactoryBot.create(:inbox, user: doctor)
  end

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
