class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { athlete: 0, trainer: 1, admin: 2 }

  # Scopes for easier querying
  scope :trainers, -> { where(role: :trainer) }
  scope :athletes, -> { where(role: :athlete) }
  scope :admins, -> { where(role: :admin) }
end
