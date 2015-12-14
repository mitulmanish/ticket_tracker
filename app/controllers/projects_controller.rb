class ProjectsController < ApplicationController

  def index
  	@projects = policy_scope(Project)
  end

  

  #def show
  #	@project = Project.find(params[:id])
  #end

  def show
    @project = Project.find(params[:id])
    authorize @project, :show?
  end

  def edit
  	@project = Project.find(params[:id])
    authorize @project, :update?
  end

  def update
  	@project = Project.find(params[:id])
    authorize @project, :update?
  	if @project.update(project_params)
  		flash[:notice] = "Project updated sucessfully"
  		redirect_to @project
  	else
  		flash.now[:alert] = "Project could not be updated"
  		render 'edit'
  	end
  end

  def destroy
  	@project = Project.find(params[:id])
  	@project.destroy
  	redirect_to projects_path
  end

  
end
