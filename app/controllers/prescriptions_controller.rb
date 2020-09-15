class PrescriptionsController < ApplicationController

  def create
    message_body = "I've lost my script, please issue a new one at a charge of €10"

    message = Message.create!(
      body: message_body,
      inbox: User.default_admin.inbox,
      outbox: User.current.outbox
    )

    PaymentProviderFactory.provider.debit_card(User.current)

    redirect_back(
      fallback_location: message_path(message),
      notice: "Message has been sent!"
    )

  rescue RuntimeError
    redirect_back(
      fallback_location: message_path(message),
      notice: "Something went wrong. Please try again later."
    )
  end
end