class PhotosController < ApplicationController
  access_control do
    allow :administrator
    allow :edytor, :except => [:destroy, :edit, :update]
    allow :moderator, :except => [:destroy, :new, :create]
    allow logged_in, :to => [:index, :show]
    allow anonymous, :to => [:index, :show]
  end

  # GET /photos
  # GET /photos.xml
  def index
    @photos = Photo.find(:all, :conditions => ['article_id is null'], :order => 'created_at DESC')
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @photos }
    end
  end

  # GET /photos/1
  # GET /photos/1.xml
  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /photos/new
  # GET /photos/new.xml
  def new
    @article = Article.find_by_id(params[:article_id])
    @photo = Photo.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /photos/1/edit
  def edit
    @photo = Photo.find(params[:id])
  end

  # POST /photos
  # POST /photos.xml
  def create
     if params[:Filedata]
      @photo = Photo.new(:swfupload_file => params[:Filedata])
      if @photo.save
        render :partial => 'photo', :object => @photo
      else
        render :text => "error"
      end
     elsif params[:article_id]
        @photo = Photo.new(params[:photo])
        @article = Article.find_by_id(params[:article_id])
        @photo.article_id = @article.id
        @photo.user_id = current_user.id if current_user
        if @photo.save
          flash[:notice] = 'Zdjęcie zostało dodane do artykułu!'
          redirect_to admin_articles_path
        else
          render :action => :new
        end
     elsif
        @photo = Photo.new(params[:photo])
        @photo.user_id = current_user.id if current_user
        if @photo.save
          flash[:notice] = 'Zdjęcie zostało dodane'
          redirect_to photos_path
        else
          render :action => :new
        end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.xml
  def update
    @photo = Photo.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        flash[:notice] = 'Photo was successfully updated.'
        format.html { redirect_to(@photo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.xml
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to(photos_url) }
      format.xml  { head :ok }
    end
  end
end
