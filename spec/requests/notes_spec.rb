require 'rails_helper'
require 'jwt_authentication'

describe 'Notes' do
  context 'CRUD Notes' do
    let(:user) { FactoryGirl.create(:user) }

    it 'a user can create notes with title, content and a file' do
      note = FactoryGirl.attributes_for(:shared_note)
      token = JWTAuthentication.encode({user_id: user.id})

      post '/notes', params: {note: note}, headers: { Authorization: "Bearer #{token}"}

      expect(response).to be_success

      expect(json['note']['user_id']).to be(user.id)
    end

    it 'a user can see its own shared notes' do
      created_notes = 5
      FactoryGirl.create_list(:shared_note, created_notes, user: user)
      token = JWTAuthentication.encode({user_id: user.id})

      get "/users/#{user.id}/notes", params: {}, headers: { Authorization: "Bearer #{token}" }

      expect(response).to be_success
      expect(json.count).to be(created_notes)
    end

    it 'a user can see its own private notes' do
      created_notes = 5
      FactoryGirl.create_list(:private_note, created_notes, user: user)
      token = JWTAuthentication.encode({user_id: user.id})

      get "/users/#{user.id}/notes", params: {}, headers: { Authorization: "Bearer #{token}" }

      expect(response).to be_success
      expect(json.count).to be(created_notes)
    end

    it 'a user can update its notes' do
      note = FactoryGirl.create(:shared_note, user: user)
      note_attributes = { shared: false }

      token = JWTAuthentication.encode({user_id: user.id})

      put "/notes/#{note.id}", params: {note: note_attributes}, headers: { Authorization: "Bearer #{token}"}

      expect(response).to be_success

      expect(json['note']['shared']).to be(false)
    end

    it 'a user can delete its notes' do
      note = FactoryGirl.create(:shared_note, user: user)

      token = JWTAuthentication.encode({user_id: user.id})

      delete "/notes/#{note.id}", params: {}, headers: { Authorization: "Bearer #{token}"}

      expect(response).to be_success

      expect(json['message']).to eq('The note was successfully deleted!')
    end
  end

  context 'Sharable Notes' do
    let(:user) { FactoryGirl.create(:user) }
    let(:another_user)  { FactoryGirl.create(:user, email: 'test2@factory.com') }

    it 'a user can see another user shared notes' do
      created_notes = 5
      FactoryGirl.create_list(:shared_note, created_notes, user: another_user)
      token = JWTAuthentication.encode({user_id: user.id})

      get "/users/#{another_user.id}/notes", params: {}, headers: { Authorization: "Bearer #{token}" }

      expect(response).to be_success
      expect(json.count).to be(created_notes)
    end

    it 'a user can not see another user private notes' do
      created_notes = 5
      FactoryGirl.create_list(:private_note, created_notes, user: another_user)
      FactoryGirl.create_list(:shared_note, created_notes, user: another_user)
      token = JWTAuthentication.encode({user_id: user.id})

      get "/users/#{another_user.id}/notes", params: {}, headers: { Authorization: "Bearer #{token}" }

      expect(response).to be_success
      expect(json.count).to be(created_notes)
    end


  end
end