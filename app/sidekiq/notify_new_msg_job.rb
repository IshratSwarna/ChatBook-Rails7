class NotifyNewMsgJob
  include Sidekiq::Job

  def perform(user_id)
    @current_user = User.find(user_id)
    if @current_user
      puts "Hello from notify new msg"
    else
      puts "failed"
    end
    # Do something
  end
end
