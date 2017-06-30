require 'rails_helper'

RSpec.describe Note, type: :model do

  context 'Validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
    it { should validate_inclusion_of(:shared).in_array([true, false]) }
  end

  context 'Instantiation' do
    it { should have_attached_file(:attachment) }
    it { should validate_attachment_content_type(:attachment)
            .allowing('image/jpg', 'image/jpeg', 'image/png', 'image/gif', 'application/pdf')
            .rejecting('text/plain', 'text/xml') }
  end

  context 'Associations' do
    it { should belong_to(:user) }
  end

  context 'Scope :shared' do
    let(:shared_note) { FactoryGirl.create(:shared_note) }
    let(:private_note) { FactoryGirl.create(:private_note) }

    it 'should include all notes that are being shared' do
      expect(Note.shared).to include(shared_note)
    end
    it 'should exclude any note that is not shared' do
      expect(Note.shared).not_to include(private_note)
    end
  end
end