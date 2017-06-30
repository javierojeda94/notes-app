class Note < ApplicationRecord

  validates_presence_of :title, :content
  validates_inclusion_of :shared, in: [true, false]

  belongs_to :user

  scope :shared, -> { where(shared: true) }

  has_attached_file :attachment, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/images/:style/missing.png'
  validates_attachment_content_type :attachment, :content_type => ['image/jpg', 'image/jpeg', 'image/png', 'image/gif', 'application/pdf']
end
