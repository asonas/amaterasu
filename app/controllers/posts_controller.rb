class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :post, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @groups = Group.all.map {|g| [g.name, g.id]}
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  def write
  end

  def deliver
    users = User.where(email: params[:post][:mail_addresses].split(","))
    users = users + User.where(group_id: params[:post][:group_ids])

    users.each do |user|
      UserMailer.notification(user: user, title: params[:post][:title], body: params[:post][:body]).deliver
    end
    redirect_to posts_path
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to posts_path, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to posts_path, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:template_name, :title, :body)
    end
end
