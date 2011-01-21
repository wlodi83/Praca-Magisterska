class ArticlesController < ApplicationController
  layout :choose_layout

  include Galdomedia::TinymceFilemanager
  # akceptacja tylko plików formatu jpeg i gif
  image_accept_mime_types ['image/jpeg', 'image/gif']

  # limit rozmiaru zdjęć do 5MB
  image_file_size_limit 5.megabytes

  # akceptacja formatów filmu .avi, flash, oraz quicktime
  media_accept_mime_types ['video/mpeg', 'video/x-msvideo', 'video/msvideo', 'video/quicktime', 'video/x-flv', 'application/x-shockwave-flash']

  # limit rozmiaru plików video do 150MB
  media_file_size_limit 150.megabytes

  #miniaturki zdjęć tzw thumbnails tworzone w folderze '_small_'
  thumbs_subdir 'small'

  #zdjęcia zapisywane w katalogu RAILS_ROOT/public/manager/images a miniaturki w RAILS_ROOT/public/manager/images/_small_
  image_save_into_public_subdir 'images/manager/article_images'

  #pliki video zapisywane w katalogu RAILS_ROOT/public/manager/media a miniaturki w RAILS_ROOT/public/manager/media/_small_
  media_save_into_public_subdir 'images/manager/article_media'

  access_control do
    allow :administrator
    allow :edytor, :except => [:destroy, :edit, :update, :comment]
    allow :moderator, :except => [:destroy, :new, :create, :comment]
    allow logged_in, :to => [:index, :show, :comment]
    allow anonymous, :to => [:index, :show, :comment]
  end

  def admin
    @articles = Article.all
    @authors = Author.find(:all)

    respond_to do |format|
      format.html # admin.html.erb
      format.xml  { render :xml => @articles }
    end
  end
  
  # GET /articles
  # GET /articles.xml
  def index
    @articles = Article.paginate(:page => params[:page], :order => 'published_at DESC',
                                 :conditions => ["published = ?", true],
                                 :per_page => 3)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
      format.pdf do
          render :pdf => "#{@article.title}",
                 :template => 'articles/show.pdf.erb',
                 :layout => 'pdf'
      end
    end
  end

  def comment
    comment = Comment.new(params[:comment])
    comment.user_id = current_user.id if current_user
    Article.find(params[:id]).add_comment(comment)
    if comment.valid?
      flash[:notice] = "Twój komentarz został dodany"
      redirect_to :action => "show", :id => params[:id]
    else
      flash[:error] = "Twój komentarz nie został dodany"
      redirect_to :action => "show", :id => params[:id]
    end
  end
  
  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
    @article_photos = @article.photos
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])
    @article.user_id = current_user.id if current_user
    respond_to do |format|
      if @article.save
         @article.photos.each do |photo|
            photo.user_id = current_user.id if current_user
            photo.save
      end
        flash[:notice] = 'Artykuł został poprawnie dodany do bazy danych.'
        format.html { redirect_to(@article) }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.find(params[:id])
    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = 'Artykuł został poprawiony i zapisany do bazy danych.'
        format.html { redirect_to(@article) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end

  private
  def choose_layout
    if ['index'].include? action_name
      'application'
    elsif ['admin'].include? action_name
      'list_of_articles'
    elsif ['show'].include? action_name
      'show_article'
    else
      'articles'
  end
end
end
