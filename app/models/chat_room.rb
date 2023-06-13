class ChatRoom < ApplicationRecord
  validates_uniqueness_of :title
  scope :public_rooms, -> {where(is_private: false)}
  after_create_commit { broadcast_if_public }
  has_many :messages
  has_many :participants, dependent: :destroy

  def broadcast_if_public 
    broadcast_append_to "chat_rooms" unless self.is_private
  end

  def self.create_private_room(users, room_name)
    single_room = ChatRoom.create(title: room_name, is_private: true)
    users.each do |user|
      Participant.create(user_id: user.id, chat_room_id: single_room.id)
    end
    return single_room
  end
end
