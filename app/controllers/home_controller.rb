class HomeController < ApplicationController
  def index
     @contributions = Contribution.where(["contr_type = 'post' and contr_subtype='url'"]).all.order('upvote DESC');
  end
  
  def new
    @contributions = Contribution.where(["contr_type = 'post'  and (contr_subtype = 'ask' or contr_subtype = 'url')"]).all.order('CREATED_AT DESC');
  end
  
  def ask
     @contributions = Contribution.all;
  end
end
