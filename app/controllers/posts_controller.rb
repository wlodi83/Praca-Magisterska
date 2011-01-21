class PostsController < ApplicationController
  layout :choose_layout
   access_control do
    allow :administrator
    allow :edytor, :except => [:destroy]
    allow :moderator, :except => [:destroy]
   # allow :owner, :of => :post, :to => [:new, :create, :edit, :update]
    allow logged_in, :to => [:new, :create, :edit, :update]
  end
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(:content => params[:post][:content], :topic_id => params[:post][:topic_id], :user_id => current_user.id)
    if @post.save
      @topic = Topic.find(@post.topic_id)
      @topic.update_attributes(:last_poster_id => current_user.id, :last_post_at => Time.now)
      flash[:notice] = "Successfully created post."
      redirect_to "/topics/#{@post.topic_id}"
    else
      render :action => 'new'
    end
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def update
  @post = Post.find(params[:id])
  if @post.update_attributes(params[:post])
    @topic = Topic.find(@post.topic_id)
    @topic.update_attributes(:last_poster_id => current_user.id, :last_post_at => Time.now)
    flash[:notice] = "Successfully updated post."
    redirect_to "/topics/#{@post.topic_id}"
  else
    render :action => 'edit'
  end
end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "Successfully destroyed post."
    redirect_to forums_url
  end
  private
  def choose_layout
    if ['index', 'new', 'edit', 'show', 'create'].include? action_name
      'forum'
    else
      'application'
    end
  end
end
