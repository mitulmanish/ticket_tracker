class TicketsController < ApplicationController
  before_action :set_project
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]
  def index
    @tickets = @project.tickets.all
  end

  def new
    @ticket = @project.tickets.build
    authorize @ticket, :create?
  end

  def create
    @ticket = @project.tickets.build(ticket_params)
    @ticket.author = current_user
    authorize @ticket, :create?
    if @ticket.save
      flash[:notice] = "New ticket created for #{@project.name}"
      redirect_to project_ticket_path(@project, @ticket)
    else
      flash[:alert] = "Ticket could not be created"
      render "new"
    end
  end

  def show
    authorize @ticket, :show?
     @comment = @ticket.comments.build(state_id: @ticket.state_id)
  end

  def edit
    authorize @ticket, :update?
  end

  def update
    authorize @ticket, :update?
    if @ticket.update(ticket_params)
      flash[:notice] = "Ticket updated for #{@project.name}"
      redirect_to project_ticket_path(@project, @ticket)
    else
      flash[:alert] = "Ticket updated"
      render "edit"
    end
  end

  def destroy
    authorize @ticket , :destroy?
    @ticket.destroy
    flash[:notice] = "The ticket has been succcessfully deleted"
    redirect_to @project
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_ticket
    @ticket = @project.tickets.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:name, :description)
  end

end
