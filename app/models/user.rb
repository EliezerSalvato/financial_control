class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :groups
  has_many :categories
  has_many :cards

  attr_writer :login

  validates :user_name, uniqueness: true
  validates :user_name, :first_name, :password_confirmation, presence: true

  def to_s
    full_name
  end

  def login
    @login || user_name || email
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup

    if (login = conditions.delete(:login))
      where(conditions.to_h).find_by(
        ['(LOWER(user_name) = :value OR LOWER(email) = :value)', { value: login.downcase }]
      )
    elsif conditions.key?(:user_name) || conditions.key?(:email)
      find_by(conditions.to_h)
    end
  end
end
