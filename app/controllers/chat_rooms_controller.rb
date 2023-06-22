class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_status

  def index
    @chat_room = ChatRoom.new
    @chat_rooms = ChatRoom.public_rooms
    @users = User.all_except(current_user)
    current_user.notifications.mark_as_read!
    @notifications = current_user.notifications.reverse
  end

  def new
    @chat_room = ChatRoom.new
  end

  def create 
    @chat_room = ChatRoom.create(chat_room_params)
  end

  def show
    @single_room = ChatRoom.find(params[:id])

    @chat_room = ChatRoom.new
    @chat_rooms = ChatRoom.public_rooms

    @message = Message.new 
    @messages = @single_room.messages.order(created_at: :asc)

    @users = User.all_except(current_user)
    
    current_user.notifications.mark_as_read!
    @notifications = current_user.notifications.reverse
    render 'index'
  end

  private

  def chat_room_params
    params.require(:chat_room).permit(:title)
  end

  def set_status 
    current_user.update!(status: User.statuses[:online]) if current_user
  end
end
