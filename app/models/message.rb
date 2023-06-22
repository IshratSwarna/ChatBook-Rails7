class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  before_create :confirm_participant
  after_create_commit { broadcast_notifications }
  after_create_commit { broadcast_append_to chat_room }
  has_noticed_notifications

  def confirm_participant
    return unless chat_room.is_private

    is_participant = Participant.where(user_id: user.id, chat_room_id: chat_room.id).first 
    throw :abort unless is_participant
  end

  def broadcast_notifications
    other_users = User.all_except(user)
    other_users.each do |other_user|
      MessageNotification.with(message: self).deliver_later(other_user)

      broadcast_prepend_to "notifications_#{other_user.id}",
                            target: "notifications_#{other_user.id}",
                            partial: "notifications/notification",
                            locals: {user: user, chat_room:, unread: true }
    end
  end

  def notify_new_msg
    NotifyNewMsgJob.perform_in(5.seconds, user.id)
  end
end
