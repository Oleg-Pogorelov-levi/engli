class ApplicationController < ActionController::Base  
  include PublicActivity::StoreController

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :forbid_user_vote!, only: [:vote]
  after_action :add_recipient_id!, only: [:vote]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::RoutingError, with: :record_not_found

  def shared_vote(instance)
    if params[:vote] == 'up'
      if instance.vote_bool == 0
        if !current_user.voted_for? instance
          instance.liked_by current_user
        else
          instance.undisliked_by current_user
        end
      else
        if current_user.voted_down_on? instance
          instance.undisliked_by current_user
        else
          instance.liked_by current_user
        end
      end
      instance.vote_bool = 1
      instance.save
      PublicActivity::Activity.last.destroy
    else
      if instance.vote_bool == 1
        if !current_user.voted_for? instance
          instance.downvote_from current_user
        else
          instance.unliked_by current_user
        end
      else
        if current_user.voted_up_on? instance
          instance.unliked_by current_user
        else
          instance.downvote_from current_user
        end
      end
      instance.vote_bool = 0
      instance.save
      PublicActivity::Activity.last.destroy
    end

    if instance.vote_registered? or !current_user.voted_for? instance
      instance.set_carma(params[:vote], current_user)
      message = params[:vote] == 'up' ? 'Liked your' : 'Disliked your'
      flash[:notice] = 'Thanks for your vote!'
    else
      flash[:danger] = 'You\'ve already voted that post!'
    end
  end

  def like_dislike!
    last_active = PublicActivity::Activity.last
    if last_active.trackable_type == 'Phrase'
      phrase_like = Phrase.find(last_active.trackable_id)
      if phrase_like.vote_bool == 1
        last_active.like = 1
        last_active.save
      else
        last_active.like = 0
        last_active.save
      end
    else
      last_active.save
    end
  end

  private

  def record_not_found(e)
    render 'errors/not_found', :status => 404, :layout => 'error'
  end

  def forbid_user_vote!
    if params[:controller] == 'examples'
      phrase = Phrase.friendly.find(params[:phrase_id])
      cheater = phrase.examples
        .find_by(id: params[:example_id]).user == current_user
    else
      cheater = Phrase.friendly.find(params[:id]).user == current_user
    end

    if cheater
      flash[:danger] = 'You can\'t vote for yourself!'
      redirect_back fallback_location: phrase_path(:id)
    end
  end

  def add_recipient_id!
    @activ = PublicActivity::Activity.all
    @activ.each do |t|
      begin
        if t.trackable_type == 'Phrase'
          find_phrase = Phrase.find(t.trackable_id)
          t.recipient_id = find_phrase.user_id
          if t.owner_id == t.recipient_id
            t.recipient_id = nil
          end
          t.save
        else
          t.recipient_id = nil
          t.save      
        end
      rescue 
        break
      end
    end
    like_dislike!
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up, keys: [
        :username, 
        :email, 
        :password, 
        :password_confirmation
      ]
    )
  end

end


