class Admin::UsersController < Admin::ApplicationController
	before_action :set_user, only: [:show, :edit, :update, :destroy, :archive]	
  before_action :set_projects, only: [:new, :edit, :update, :create]  
  def index
  	@users = User.excluding_archived.order(:email)
  end
  def new
  	@user = User.new
  end
  def create
  	@user = User.new(user_params)
    build_roles_for(@user)
  	if @user.save
  		flash[:notice] = "New User Created"
  		redirect_to admin_users_path
  	else
  		flash[:notice] = "Not able to create User "
  		render "new"
  	end
  end

  def show
  end

  def destroy
  end

  def edit
  end

  def update
  	if params[:user][:password].blank?
  		params[:user].delete(:password)
  	end
    User.transaction do
      @user.roles.clear
      build_roles_for(@user)
    end
  	if @user.update(user_params)
  		flash[:notice] = "Successfully Updated"
  		redirect_to admin_users_path
  	else
  		flash[:alert] = "Could not update successfully"
  		render "edit"
  	end
  end
  def archive
    if @user = current_user
      flash[:alert] = "You can't archive yourself"
    else
    @user.archive
    flash[:notice] = "The User has been archived"
    end
    redirect_to admin_users_path
  end

  private
  def user_params
  	params.require(:user).permit(:email, :password)
  end
  def set_projects 
    @projects = Project.order(:name)
  end

  def set_user
	@user = User.find(params[:id])
  end

  def build_roles_for(user)
    role_data = params.fetch(:roles, [])
    role_data.each do |project_id, role_name|
      if role_name.present?
      user.roles.build(project_id: project_id, role: role_name)
      end
    end
  end
end
