class PagesController < ApplicationController
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
  image_save_into_public_subdir 'manager/page_images'

  #pliki video zapisywane w katalogu RAILS_ROOT/public/manager/media a miniaturki w RAILS_ROOT/public/manager/media/_small_
  media_save_into_public_subdir 'manager/page_media'

  access_control do
    allow :administrator
    allow :edytor, :except => [:destroy, :edit, :update]
    allow :moderator, :except => [:destroy, :new, :create]
    allow logged_in, :to => [:show]
    allow anonymous, :to => [:show]
  end
  
  def index
    @pages = Page.find(:all)
  end

  def show
    @page = Page.find(params[:id])
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])
    @page.save!
    flash[:notice] = 'Strona została zapisana'
    redirect_to :action => 'index'
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

  def edit
    @page = Page.find(params[:id].to_i)
  end

  def update
  @page = Page.find(params[:id].to_i)
  @page.attributes = params[:page]
  @page.save!
  flash[:notice] = 'Strona została zapisana'
  redirect_to :action => 'index'
  rescue
    render :action => 'edit'
  end

  def destroy
  @page = Page.find(params[:id].to_i)
  if @page.destroy
    flash[:notice] = "Strona została usunięta"
  else
    flash[:error] = "Wystąpił błąd podczas usuwania strony"
  end
  redirect_to :action => 'index'
  end

end
