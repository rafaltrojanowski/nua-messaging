class PrescriptionsController < ApplicationController

  def create
    message_body = "I've lost my script, please issue a new one at a charge of €10"

    message = Message.create(
      body: message_body,
      inbox: User.default_admin.inbox,
      outbox: User.current.outbox
    )

    PaymentProviderFactory.provider.debit_card(User.current)

    redirect_to :back, notice: "Message has been sent!"
  end
end