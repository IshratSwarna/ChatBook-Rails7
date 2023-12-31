class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "appearance_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_stream_from "appearance_channel"
    offilne
  end

  def online
    status = User.statuses[:online]
    broadcast_new_status(status)
  end

  def away
    status = User.statuses[:away]
    broadcast_new_status(status)
  end

  def offline
    status = User.statuses[:offilne]
    broadcast_new_status(status)
  end

  def receive(data)
    ActionCable.server.broadcast('appearance_channel', data)
  end

  private

  def broadcast_new_status(status)
    current_user.update!(status: status)
  end
end
