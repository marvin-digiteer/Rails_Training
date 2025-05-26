class Post < ApplicationRecord
    validates :title, presence: true, length: { minimum: 5, maximum: 255 }, uniqueness: { case_sensitive: false }
    validates :body, presence: true, length: { minimum: 5, maximum: 1500 }

    belongs_to :customer
  end
  
