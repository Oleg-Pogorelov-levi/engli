class PhrasesController < ApplicationController
  before_action :phrase_friendlyid!, only: [:edit, :update, :destroy, :vote]
  before_action :check_user!, only: [:edit, :update, :destroy]
  before_action :check_user_before_example_deletion!, only: [:delete_example]
  def index
    @phrases = Phrase.includes(:user).paginate(page: params[:page], per_page: 10)
  end

  def new
    @phrase = current_user.phrases.new
    @phrase.examples.build
  end

  def show
    @phrase = Phrase.friendly.find(params[:id])
    @example = @phrase.examples.new
    @examples = @phrase.examples.paginate(page: params[:page], per_page: 10)
  end

  def create
  	@phrase = current_user.phrases.new(phrase_params)
  	if @phrase.save
  		flash[:notice] = 'Phrase has been created'
  		redirect_to phrases_path
  	else
  		flash[:danger] = @phrase.errors.full_messages.to_sentence
  		render :new
  	end
  end

  def edit
  end

  def update
  	if @phrase.update(phrase_params)
  		flash[:notice] = 'Phrase has been updated'
  		redirect_to phrases_path
  	else
  		flash[:danger] = @phrase.errors.full_messages.to_sentence
  		render :new
  	end
  end

  def vote
    shared_vote(@phrase)
    redirect_back(fallback_location: root_path)
    @phrase.vote_weight = @phrase.get_likes.size - @phrase.get_dislikes.size
    @phrase.save
  end

  def destroy
    @phrase.destroy
    redirect_to phrases_path
  end

  private

  def phrase_params
  	params.require(:phrase).permit(
      :phrase, 
      :translation, 
      :category, 
      :user_id, 
      :phrase_id, 
      examples_attributes: [:example, :user_id]
    )
  end

  def phrase_friendlyid!
	  @phrase = Phrase.friendly.find(params[:id])
  end

  def check_user!
    unless @phrase.author? current_user
      flash[:danger] = 'You don\'t author of phrase, go away!'
      redirect_back(fallback_location: root_path)
    end
  end



end
