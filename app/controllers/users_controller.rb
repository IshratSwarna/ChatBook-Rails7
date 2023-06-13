class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @users = User.all_except(current_user)

    @chat_room = ChatRoom.new
    @chat_rooms = ChatRoom.public_rooms
    @chat_room_name = get_name(@user, current_user)

    @single_room = ChatRoom.where(title: @chat_room_name).first || ChatRoom.create_private_room([@user, current_user], @chat_room_name)

    @message = Message.new
    @messages = @single_room.messages.order(created_at: :asc)

    render 'chat_rooms/index'
  end

  private 
  def get_name(user1, user2)
    users = [user1, user2].sort 
    return "private_#{users[0].id}_#{users[1].id}"
  end
end
