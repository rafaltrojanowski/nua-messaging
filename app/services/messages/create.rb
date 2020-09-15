module Messages
  class Create

    attr_reader :message, :errors

    def initialize()
      @message = nil
      @errors = []
    end
    
    def call(attrs:, original_message_id: nil)
      @message = Message.new(attrs.merge(
        outbox: User.current.outbox,
        inbox: User.default_doctor.inbox
      ))

      unless @message.save
        @errors = message.errors
      end

      self
    end

    def success?
      @message.valid?
    end
  end
end