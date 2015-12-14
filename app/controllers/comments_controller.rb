class CommentsController < ApplicationController
	before_action :set_ticket
	def create
		@comment = @ticket.comments.build(comment_params)
		@comment.author = current_user
		authorize @comment, :create?
		if @comment.save
			flash[:notice] = "New comment created"
			redirect_to [@ticket.project, @ticket]
		else
			flash[:alert] = "Comment could not be created"
			render "tickets/show"
		end
	end
private
	def set_ticket
		@ticket = Ticket.find(params[:ticket_id])
	end
	def comment_params
		params.require(:comment).permit(:text, :state_id)
	end
end
