class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :tweets
  has_many :comments

  validates :nickname, presence: true, length: { maximum: 6 } #文字数制限のバリデーション。これを設定したらtext_fieldタグに付いているmaxlength: 6を削除
end
