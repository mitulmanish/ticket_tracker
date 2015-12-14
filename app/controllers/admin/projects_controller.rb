class Admin::ProjectsController < Admin::ApplicationController

  def new 
  	@project = Project.new
  end

  def create
  	@project = Project.new(project_params)

  	if @project.save
  		flash[:notice] = "Project saved sucessfully"
  		redirect_to @project
  	else
  		flash[:alert] = "Project could not be created"
  		render 'new'
  	end
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
  
  private
  def project_params
  	params.require(:project).permit(:name, :description)
  end
end
