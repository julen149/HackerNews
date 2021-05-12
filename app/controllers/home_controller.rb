class HomeController < ApplicationController
  def index
     @contributions = Contribution.where(["contr_type = 'post' and contr_subtype='url'"]).all.order('upvote DESC');
  end
  
  def new
    @contributions = Contribution.where(["contr_type = 'post'  and (contr_subtype = 'ask' or contr_subtype = 'url')"]).all.order('CREATED_AT DESC');
  end
  
  def ask
    @contributions = Contribution.where(["contr_type = 'post'  and (contr_subtype = 'ask')"]).all.order('upvote DESC');
  end
  
  def threads
    if user_signed_in?
      @contributions = Contribution.where("(contr_type = 'comment' or contr_type = 'reply') and user_id=?", current_user.id).all.order('CREATED_AT DESC');
    else
      redirect_to new_user_session_path;
    end
  end
  
end
