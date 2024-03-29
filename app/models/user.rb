class User < ActiveRecord::Base
  attr_accessible :name, :password_digest, :password, :password_confirmation
  
  validates :name, presence: true, uniqueness: true
  has_secure_password
  
end
