class Message < ApplicationRecord

  belongs_to :inbox
  belongs_to :outbox

  validates :body, presence: true

  after_create :increment_unread_messages_count
  after_save :decrement_unread_messages_count,
   if: Proc.new { read_changed? }

  def increment_unread_messages_count
    inbox.increment(:unread_messages_count) unless self.read?
  end

  def decrement_unread_messages_count
    inbox.decrement(:unread_messages_count, 1) if self.read_change == [false, true]
  end
end