require 'rails_helper'

RSpec.describe ExamplesController do
  let(:user) { create(:user) }

  describe 'POST show/:id/create' do
    let(:phrase) { create(:phrase, user: user) }
    before { sign_in user }

    context 'when the example is valid' do
      it 'creates an example and redirects to phrase :show path' do
        params = { 
          params: { 
            phrase_id: phrase.id, 
            example: attributes_for(:example) 
          } 
        }
        params[:params][:example][:user_id] = user.id

        post :create, params

        expect(flash[:notice]).not_to be_empty
        expect(response).to redirect_to phrase_path(phrase)
      end
    end

    context 'when the example is invalid' do
      it 'doesn\t create and example and redirects to phrase :show path' do
        post :create, params: { 
          phrase_id: phrase.id, 
          example: attributes_for(:example, :invalid) 
        }

        expect(flash[:danger]).to be_empty
        expect(response).to redirect_to phrase_path(phrase)
      end
    end
  end

  describe 'DELETE destroy/:id' do
    let(:phrase) { create(:phrase, user: user) }
    let(:example) { create(:example, phrase: phrase, user: user) }

    context 'when user is the user of the example' do
      it 'deletes an example and redirects to phrase :show path' do
        sign_in user

        delete :destroy, params: { phrase_id: phrase.id, id: example.id }

        expect(flash[:notice]).not_to be_empty
        expect(response).to redirect_to phrase_path(phrase.id)
      end
    end

    context 'when user is the user of the phrase' do
      it 'deletes an example and redirects to phrase :show path' do
        another_user = create(:user)
        another_example = create(:example, phrase: phrase, user: another_user)
        sign_in user

        delete :destroy, params: { 
          phrase_id: phrase.id, 
          id: another_example.id 
        }

        expect(flash[:notice]).not_to be_empty
        expect(response).to redirect_to phrase_path(phrase.id)
      end
    end

    context 'when user is not an user of example/phrase' do
      it 'does not delete an example and redirects to phrase_path' do
        another_user = create(:user)
        sign_in another_user

        delete :destroy, params: { phrase_id: phrase.id, id: example.id }

        expect(response).to redirect_to phrase_path(phrase.id)
      end
    end
  end
end