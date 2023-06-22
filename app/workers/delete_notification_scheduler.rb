require 'sidekiq-scheduler'

class DeleteNotificationScheduler
  # Check the publish_at column of the post table
  # If the time is less than the current time,
  # then publish the post by calling the publish method

  include Sidekiq::Worker

  def perform
    puts "Hello from delete notification scheduler"
    notifications = Notification.where.not(read_at: nil)
    last_notification = notifications.order(created_at: :desc).last
    last_notification.destroy if last_notification.present?
  end
end