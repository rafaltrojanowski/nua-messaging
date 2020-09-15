class PaymentProviderFactory
  class Provider
    def debit_card(user) 
      Payment.create!(user: user)
    end
  end

  def self.provider
    @provider ||= Provider.new
  end
end
