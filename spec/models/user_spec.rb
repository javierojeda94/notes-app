require 'rails_helper'

RSpec.describe User, type: :model do

  context 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }

    it { should have_secure_password }
  end

  context 'Associations' do
    it { should have_many(:notes) }
  end
end