class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :contribution
  has_many :vote
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
