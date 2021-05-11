class ContributionsController < ApplicationController
  before_action :set_contribution, only: [:show, :edit, :update, :destroy]
  before_action :authenticate, only: [:create_posts_api, :create_reply_api]

  # GET /contributions
  # GET /contributions.json
  def index
    @contributions = Contribution.all
  end

  # GET /contributions/1
  # GET /contributions/1.json
  def show
  end

  # GET /contributions/new
  def new
    @contribution = Contribution.new
  end

  # GET /contributions/1/edit
  def edit
  end

  # POST /contributions
  # POST /contributions.json
  def create
    @contribution = Contribution.new(contribution_params)
    
    if user_signed_in?
      @contribution.user_id = current_user.id
    end

    respond_to do |format|
      if @contribution.save
        if @contribution.contr_subtype == 'url' and @contribution.content != ''
          @discuss = Contribution.new
          @discuss.parent_id = @contribution.id
          @discuss.contr_type = 'comment' #no he trobat els tipus de contributions que hi ha per tant inuteixo que es diran aixi
          @discuss.user = @contribution.user #aqui fico que el comentari es de la mateixa persona que el submision -> per cambiar
          @discuss.content = @contribution.content
          @discuss.save
        end
        format.html { redirect_to @contribution, notice: 'Contribution was successfully created.' }
        format.json { render :show, status: :created, location: @contribution }
      else
        if @contribution.contr_subtype == 'url'
          format.html { redirect_to root_path }
        else
          format.html { render :new }
          format.json { render json: @contribution.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
  def discuss
    set_contribution
    if @contribution.contr_type != 'post'
      raise ActiveRecord::RecordNotFound, 'Trying to discuss a contribution of type '+@contribution.contr_type
    end
    @discuss = Contribution.new
    @discuss.parent_id = @contribution.id
    @discuss.contr_type = 'comment' #no he trobat els tipus de contributions que hi ha per tant inuteixo que es diran aixi
    @discuss.user = @contribution.user #aqui fico que el comentari es de la mateixa persona que el submision -> per cambiar
  end
  
  def reply
    set_contribution
    if @contribution.contr_type == 'post'
      raise ActiveRecord::RecordNotFound, 'Trying to reply a contribution of type '+@contribution.contr_type
    end
    @reply = Contribution.new
    @reply.parent_id = @contribution.id
    @reply.contr_type = 'reply'
    @reply.user = @contribution.user
  end

  # PATCH/PUT /contributions/1
  # PATCH/PUT /contributions/1.json
  def update
    respond_to do |format|
      if @contribution.update(contribution_params)
        format.html { redirect_to @contribution, notice: 'Contribution was successfully updated.' }
        format.json { render :show, status: :ok, location: @contribution }
      else
        format.html { render :edit }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def upvote
    @contribution = Contribution.find(params[:id])
    @vote = Vote.new
    @vote.user_id = current_user.id
    @vote.contribution_id = @contribution.id
    @vote.save
    if @vote.save
      @contribution.upvote += 1;
      @contribution.save
    end
    redirect_to(request.env['HTTP_REFERER'])
  end

  # DELETE /contributions/1
  # DELETE /contributions/1.json
  def destroy
    @contribution.destroy
    respond_to do |format|
      format.html { redirect_to contributions_url, notice: 'Contribution was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def api_url
    @contributions = Contribution.where(["contr_type = 'post' and contr_subtype='url'"]).all.order('CREATED_AT DESC');
    render json: @contributions
  end
  
  def api_ask
    @contributions = Contribution.where(["contr_type = 'post'  and contr_subtype = 'ask'"]).all.order('CREATED_AT DESC');
    render json: @contributions
  end
  
  def api_comment
    set_contribution
    if @contribution.nil? || @contribution.contr_type != 'comment'
      render :json => {:error => "not-found"}.to_json, :status => 404
    else
      render json: {:contribution => @contribution, :replies => @contribution.replies}.to_json, status: :ok
    end
  rescue ActiveRecord::RecordNotFound
    render_not_found
  end
  
  def api_post
    set_contribution
    if @contribution.nil? || @contribution.contr_type != 'post'
      render :json => {:error => "not-found"}.to_json, :status => 404
    else
      render json: {:contribution => @contribution, :comments => @contribution.replies}.to_json, status: :ok
    end
  rescue ActiveRecord::RecordNotFound
    render_not_found
  end
  
  def api_get_reply
    set_contribution
    if @contribution.nil? || @contribution.contr_type != 'reply'
      render :json => {:error => "not-found"}.to_json, :status => 404
    else
      render json: {:contribution => @contribution}.to_json, status: :ok
    end
  rescue ActiveRecord::RecordNotFound
    render_not_found
  end
  
  def create_posts_api
    @contribution = Contribution.new({title: params['title']})
    @contribution.user_id = @api_user.id
    @contribution.contr_type= 'post'
    @contribution.title = params[:title]

    unless params['content'].blank?
      @contribution.contr_subtype ='ask'
      @contribution.content = params['content']
    end
    unless params['url'].blank?
      @contribution.contr_subtype = 'url'
      @contribution.url = params['url']
    end
    if @contribution.save
      render json: @contribution, id: @contribution.id
    else
      render json: @contribution.errors, status: :bad_request
    end
  end
  
  def create_reply_api
    @contribution = Contribution.new({content: params['reply']})
    @contribution.user_id = @api_user.id
    @contribution.contr_type= 'reply'
    @contribution.parent_id = params[:parent_id]
    @contribution.content = params[:content]
    if @contribution.save
      render json: @contribution, id: @contribution.id
    else
      render json: @contribution.errors, status: :bad_request
    end
  end
  
  def create_comment_api
    @contribution = Contribution.new({content: params['comment']})
    @contribution.user_id = @api_user.id
    @contribution.contr_type= 'comment'
    @contribution.parent_id = params[:parent_id]
    @contribution.content = params[:content]
    if @contribution.parent.contr_type != 'post'
      render json: {:error => 'Comentari en una contribució que no es de tipus post'}
      return
    end
    if @contribution.save
      render json: @contribution, status: :ok
    else
      render json: @contribution.errors, status: :bad_request
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contribution
      @contribution = Contribution.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contribution_params
      params.require(:contribution).permit(:contr_type, :contr_subtype, :content, :user_id, :url, :upvote, :parent_id, :title)
    end
end
