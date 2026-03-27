class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :items
  has_many :item_shares, dependent: :destroy
  has_many :shared_items, through: :item_shares, source: :item

  validates :nickname, presence: true

  VALID_PASSWORD_REGEX =/\A(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{6,}\z/
  validates :password, presence: true,
            format: { with: VALID_PASSWORD_REGEX,
             message: "は英数字6文字以上が必要です"}, on: :create

end
