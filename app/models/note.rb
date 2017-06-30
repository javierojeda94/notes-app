class Note < ApplicationRecord

  belongs_to :user

  scope :shared, -> { where(shared: true) }

  has_attached_file :attachment, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/images/:style/missing.png'
  do_not_validate_attachment_file_type :attachment
end
