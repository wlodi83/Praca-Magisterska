class ForumsController < ApplicationController
  layout :choose_layout
  access_control do
    allow :administrator
    allow :edytor, :except => [:destroy]
    allow :moderator, :except => [:destroy]
    allow logged_in, :to => [:index, :show]
    allow anonymous, :to => [:index, :show]
  end
  def index
    @forums = Forum.all
  end
  
  def show
    @forum = Forum.find(params[:id])
  end
  
  def new
    @forum = Forum.new
  end
  
  def create
    @forum = Forum.new(params[:forum])
    if @forum.save
      flash[:notice] = "Successfully created forum."
      redirect_to @forum
    else
      render :action => 'new'
    end
  end
  
  def edit
    @forum = Forum.find(params[:id])
  end
  
  def update
    @forum = Forum.find(params[:id])
    if @forum.update_attributes(params[:forum])
      flash[:notice] = "Successfully updated forum."
      redirect_to @forum
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy
    flash[:notice] = "Successfully destroyed forum."
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
