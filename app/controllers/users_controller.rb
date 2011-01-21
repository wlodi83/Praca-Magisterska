class UsersController < ApplicationController
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]

  access_control do
    allow :administrator
    allow logged_in, :to => [:show, :show_by_login, :edit, :update]
    allow anonymous, :to => [:new, :create, :activate]
  end
  
  #render index.rhtml
  def index
    @users = User.find(:all)
  end

  #render show.rhtml
  def show
    @user = User.find(params[:id])
  end

  def show_by_login
    @user = User.find_by_login(params[:login])
    render :action => 'show'
  end
  
  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.register! if @user && @user.valid?
    success = @user && @user.valid?
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = "Dziękujemy za rejestrację w systemie! Przesłaliśmy do ciebie wiadomość e-mail z kodem aktywacyjnym Twojego konta."
    else
      flash.now[:error]  = "Nie można stworzyć takiego konta.  Spróbuj ponownie lub skontaktuj się z administratorem."
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    params[:user][:role_ids] ||= []
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Zmiany zostały zapisane"
      redirect_to :action => 'show', :id => @user
    else
      render :action => 'edit'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Rejestracja zakończona! Proszę zaloguj się."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "Kod aktywacji jest pusty. Kliknij w link podany w wiadomości e-mail."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "Nie możemy znaleźć użytkownika z takim kodem aktywacji -- sprawdź swoją wiadomość e-mail? Być może twoje konto nie zostało jeszcze aktywowane -- spróbuj ponownie aktywować swoje konto."
      redirect_back_or_default('/')
    end
  end

  def suspend
    @user.suspend! 
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end
  
  # There's no page here to update or destroy a user.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.
  
  protected
    def find_user
      @user = User.find(params[:id])
    end
  end
