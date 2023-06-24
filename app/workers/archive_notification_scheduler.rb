require 'sidekiq-scheduler'

class ArchiveNotificationScheduler
  
  include Sidekiq::Worker

  def perform
    puts "Hello from archive notification scheduler"
    notifications = Notification.where.not(read_at: nil).where(archived: false)
    last_notification = notifications.order(created_at: :desc).last
    last_notification.update!(archived: true)
  end
end