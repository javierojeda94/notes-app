include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :shared_note, class: Note do
    title 'Note 1'
    content 'This is the content of a public FactoryGirl-ed note'
    shared 't'
    user
    attachment { fixture_file_upload "#{Rails.root}/spec/assets/test-image.png", 'image/png' }
  end

  factory :private_note, class: Note do
    title 'Note 2'
    content 'This is the content of a private FactoryGirl-ed note'
    shared 'f'
    user
    attachment { fixture_file_upload "#{Rails.root}/spec/assets/test-image.png", 'image/png' }
  end
end 