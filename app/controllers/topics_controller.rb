class TopicsController < ApplicationController
  layout :choose_layout
  access_control do
    allow :administrator
    allow :edytor, :except => [:destroy]
    allow :moderator, :except => [:destroy]
    allow logged_in, :to => [:index, :show, :new, :create, :edit, :update]
    allow anonymous, :to => [:index]
  end
  def index
    @topics = Topic.all
  end
  
  def show
    @topic = Topic.find(params[:id])
  end
  
  def new
    @topic = Topic.new
    @post = Post.new
  end
  
def create
@topic = Topic.new(:name => params[:topic][:name], :last_poster_id => current_user.id,
                   :last_post_at => Time.now,
                   :forum_id => params[:topic][:forum_id],
                   :user_id => current_user.id)
if @topic.save
  @post = Post.new(:content => params[:post][:content],
                   :topic_id => @topic.id,
                   :user_id => current_user.id)
  if @post.save
      flash[:notice] = "Successfully created topic."
      redirect_to "/forums/#{@topic.forum_id}"
  else
      redirect :action => 'new'
  end
else
  render :action => 'new'
end
end
  
  def edit
    @topic = Topic.find(params[:id])
  end
  
  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(params[:topic])
      flash[:notice] = "Successfully updated topic."
      redirect_to @topic
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    flash[:notice] = "Successfully destroyed topic."
    redirect_to topics_url
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
