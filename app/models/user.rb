class User < ApplicationRecord

  has_secure_password

  validates_presence_of :name, :email
  validates_uniqueness_of :email

  has_many :notes
end
