class AddUnreadMessagesCountToInbox < ActiveRecord::Migration[5.0]
  def change
    add_column :inboxes, :unread_messages_count, :integer, default: 0
  end
end
