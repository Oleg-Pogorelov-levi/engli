
require 'rails_helper'

RSpec.describe PhrasesController do
  describe 'user tries to access index page' do
    context 'when not logged in ' do
      it 'redirect to log in page' do
        get :index
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'GET index' do
    it_behaves_like 'has index action'
  end

  describe 'GET show/:id' do
    it_behaves_like 'has show action', :phrase
  end

  describe 'POST create' do
    before do
      user = create(:user)
      sign_in user
    end

    context 'when the phrase is valid ' do
      it 'creates a phrase and redirects to :index page' do
        post :create, params: { phrase:  attributes_for(:phrase) }

        expect(flash[:notice]).not_to be_empty
        expect(response).to redirect_to phrases_path
      end
    end

    context 'when the phrase is invalid' do
      it 're-renders the :new page' do
        post :create, params: { phrase: attributes_for(:phrase, :invalid) }

        expect(flash[:danger]).not_to be_empty
        expect(response).to render_template :new
      end
    end
  end

  describe 'PUT update/:id' do
    let(:user) { create(:user) }
    let(:phrase) { create(:phrase, user: user) }

    context 'when the user is the author ' do
      it 'updates the phrase and redirects to phrases ' do
        sign_in user

        put :update, params: { 
          id: phrase.id, 
          phrase: attributes_for(:phrase, :update) 
        }

        expect(flash[:notice]).not_to be_empty
        expect(response).to redirect_to phrases_path
      end
    end

    context 'when the user is not an author' do
      it 'redirects to root_path' do
        not_author = create(:user)
        sign_in not_author

        put :update, params: { 
          id: phrase.id, 
          phrase: attributes_for(:phrase, :update) 
        }

        expect(flash[:danger]).not_to be_empty
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when the phrase is invalid' do
      it 're-renders the user :edit page' do
        sign_in user

        put :update, params: { 
          id: phrase.id, 
          phrase: attributes_for(:phrase, :invalid) 
        }

        expect(flash[:danger]).not_to be_empty
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE destroy/:id' do
    let(:user) { create(:user) }
    let(:phrase) { create(:phrase, user: user) }

    context 'when the user is the author' do
      it 'deletes the phrase and redirects to root_path' do
        sign_in user

        delete :destroy, params: { id: phrase.id }

        expect(response).to redirect_to phrases_path
      end
    end

    context 'when the user is not an author' do
      it 'doesn\'t delete the phrase and redirects to root_path' do
        not_author = create(:user)
        sign_in not_author

        delete :destroy, params: { id: phrase.id }

        expect(flash[:danger]).not_to be_empty
        expect(response).to redirect_to(root_path)
      end
    end
  end
  
  #vote phrase
  describe '#shared_vote phrase' do
    let(:author) { FactoryBot.create(:user) }
    let(:phrase) { FactoryBot.create(:phrase, user: author) }

    context 'user upvotes a phrase' do
      it 'ups score of a phrase' do
        sign_in author

        post :index, params: { id: phrase.id, vote: 'up' }
        controller.shared_vote(phrase)
        phrase.vote_weight = phrase.get_likes.size - phrase.get_dislikes.size
        expect(phrase.vote_weight).to eq 1
        expect(author.carma).to eq 4
      end
    end  
    
    context 'user downvotes a phrase' do
      it 'ups score of a phrase' do
        sign_in author

        post :index, params: { id: phrase.id, vote: 'down' }
        controller.shared_vote(phrase)
        phrase.vote_weight = phrase.get_likes.size - phrase.get_dislikes.size
        expect(phrase.vote_weight).to eq -1
        expect(author.carma).to eq -2
      end
    end    
  end

  #vote example
  describe '#shared_vote example' do
    let(:author) { FactoryBot.create(:user) }
    let(:example_phrase) { FactoryBot.create(:phrase, user: author) }
    let(:example) { 
      FactoryBot.create(
        :example, 
        user: author, 
        phrase: example_phrase
      ) 
    }

    context 'user upvotes a example' do
      it 'ups score of a example' do
        sign_in author

        redirect_to phrase_path(example.phrase.id)
        post :show, params: { id: example.phrase_id, vote: 'up' }
        
        controller.shared_vote(example)

        expect(author.carma).to eq 2
      end
    end
    context 'user downvotes a example' do
      it 'downs score of a example' do
        sign_in author

        redirect_to phrase_path(example.phrase.id)
        post :show, params: { id: example.phrase_id, vote: 'down' }
        
        controller.shared_vote(example)

        expect(author.carma).to eq -1
      end
    end  
  end
end


