module Messages
  class Create

    attr_reader(
      :errors, 
      :message, 
      :original_message_id
    )

    def initialize()
      @message = nil
      @errors = []
    end
    
    def call(attrs:, original_message_id: nil)
      @original_message_id = original_message_id
      @message = Message.new(attrs.merge(
        outbox: User.current.outbox,
        inbox: recipient.inbox
      ))

      unless @message.save
        @errors = message.errors
      end

      self
    end

    def success?
      @message.valid?
    end

    private

    def original_message
      @original_message ||= Message.find_by(id: original_message_id)
    end

    def recipient
      return User.default_doctor unless original_message

      if original_message.created_at < 1.week.ago
        User.default_admin
      else
        User.default_doctor
      end
    end
  end
end