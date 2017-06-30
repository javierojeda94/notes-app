class Note < ApplicationRecord

  belongs_to :user

  scope :shared, -> { where(shared: true) }
end
