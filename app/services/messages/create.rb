module Messages
  class Create

    attr_reader :message, :errors

    def initialize()
      @message = nil
      @errors = []
    end
    
    def call(message_attrs)
      @message = Message.new(message_attrs.merge(
        outbox: User.current.outbox,
        inbox: User.default_doctor.inbox
      ))

      @message.save

      self
    end

    def success?
      @message.valid?
    end
  end
end