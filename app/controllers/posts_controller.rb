class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json

  respond_to :html, :json
  def index
    @post = Post.paginate(per_page: 6,
                          page: params[:per_page],
                          order: 'created_at DESC')

      respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    begin
    @post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error "Attempt to access invalid action #{params[:id]}"
      flash[:notice] = "Invalid Action"
      redirect_to profile_path(current_user.profile_name)
    else
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @post }
    end
  end
end

  # GET /posts/new
  # GET /posts/new.json
  def new
  @user = User.find_by_profile_name(params[:id])
  unless @user
    @post = Post.new
    false
  end
  respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
  if current_user
    @post = current_user.posts.build(params[:post])
    respond_to do |format|
  if @post.save
    format.html do
    flash[:success] = 'your post has been created'
    redirect_to profile_path(@current_user.profile_name)
    format.js
    format.json { render json: @post.to_json}
  end
  else
    format.html do
      render @user
      flash[:error] = 'there was a problem'
    end
    format.json { render json: @post.to_json}
  end
    end

  else
    if current_admin
    @post = current_admin.posts.build(params[:post])
    respond_to do |format|
      if @post.save
        format.html do
          flash[:success] = 'your post has been created'
          redirect_to current_admin
          format.js
          format.json { render json: @post.to_json}
        end
      else
        format.html do
          render current_admin
          flash[:error] = 'there was a problem'
        end
        format.json { render json: @post.to_json}
      end
      end
    end
 end
end

  # PUT /posts/1
  # PUT /posts/1.json


  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to profile_path(current_user.profile_name), notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to profile_path(current_user.profile_name) }
      format.json { head :no_content }
    end
  end

  #--------gem activerecord_reputation_system installed tutorial rails casts 406-----------#
  def vote
    value = params[:type] == "up" ? 1 : -1
    @post = Post.find(params[:id])
    @post.add_or_update_evaluation(:votes, value, current_user )
    redirect_to :back
    flash[:success] = "Thanks for voting"

  end
end





