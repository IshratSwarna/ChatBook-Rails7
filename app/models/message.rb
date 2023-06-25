class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  before_create :confirm_participant
  after_create_commit { broadcast_notifications }
  after_create_commit { broadcast_append_to chat_room }
  has_many_attached :attachments, dependent: :destroy
  has_noticed_notifications

  def chat_attachment(index)
    target = attachments[index]
    return unless attachments.attached?

    if target.image?
      target.variant(resize_to_limit: [150, 150]).processed
    elsif target.video?
      target.variant(resize_to_limit: [150, 150]).processed
    end
  end

  def confirm_participant
    return unless chat_room.is_private

    is_participant = Participant.where(user_id: user.id, chat_room_id: chat_room.id).first 
    throw :abort unless is_participant
  end

  def msgNotificationWithBroadcast(other_user)
    MessageNotification.with(message: self).deliver_later(other_user)

    broadcast_prepend_to "notifications_#{other_user.id}",
                          target: "notifications_#{other_user.id}",
                          partial: "notifications/notification",
                          locals: {user: user, chat_room:, unread: true }
  end

  def broadcast_notifications
    if chat_room.is_private
      other_participant = Participant.where.not(user_id: user.id).where(chat_room_id: chat_room.id).first
      other_user = User.find(other_participant.user_id)
      msgNotificationWithBroadcast(other_user)
      
    else
      other_users = User.all_except(user)
      other_users.each do |other_user|
        msgNotificationWithBroadcast(other_user)
      end
    end
  end
end
