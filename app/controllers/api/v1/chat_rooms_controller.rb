class Api::V1::ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  def index
    @chat_rooms = ChatRoom.public_rooms
    render json: @chat_rooms, status: :ok
  end
end