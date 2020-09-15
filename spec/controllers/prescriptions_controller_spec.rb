require 'rails_helper'

RSpec.describe PrescriptionsController do
  describe "POST create" do
    let!(:patient) { FactoryBot.create(:user, is_patient: true) }
    let!(:patient_outbox) { FactoryBot.create(:outbox, user: patient) }
    let!(:admin) { FactoryBot.create(:user, is_admin: true) }
    let!(:admin_inbox) { FactoryBot.create(:inbox, user: admin) }
    let!(:message) { FactoryBot.create(:message) }

    before { request.env['HTTP_REFERER'] = message_path(message) }

    context 'when success' do
      it "calls API" do
        expect_any_instance_of(PaymentProviderFactory::Provider)
          .to receive(:debit_card)
          .with(patient)
          .once
        post :create
      end

      it "creates Message and Payment" do
        expect{ post :create }.to change{Payment.count}.from(0).to(1)
          .and change{Message.count}.from(1).to(2)
      end

      it "redirects back" do
        post :create
        expect(subject).to redirect_to(message_path(message))
      end
    end

    context 'when failure' do
      it 'handles exception gracefully' do
        allow_any_instance_of(PaymentProviderFactory::Provider)
          .to receive(:debit_card)
          .with(patient).and_raise(RuntimeError)

        post :create

        expect(subject).to redirect_to(message_path(message))
        expect(flash[:alert]).to be_present
      end
    end
  end
end