class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  scope :all_except, -> (user) {where.not(id: user)}
  after_create_commit { broadcast_append_to "users" }
  after_update_commit { broadcast_update }
  has_many :messages
  has_many :notifications, as: :recipient, dependent: :destroy

  enum status: %i[offline away online]

  def status_to_css
    case status
    when 'online'
      'bg-success'
    when 'away'
      'bg-warning'
    when 'offline'
      'bg-dark'
    else
      'bg-dark'
    end
  end

  def broadcast_update
    broadcast_replace_to 'user_status', partial: 'users/status', user: self
  end
end
