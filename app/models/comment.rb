class Comment < ActiveRecord::Base
  belongs_to :author, class_name: "User"
  belongs_to :ticket
  belongs_to :state
  belongs_to :previous_state, class_name: "State"
  before_create :set_previous_state
  after_create :set_ticket_state
  validates :text, presence: true
  delegate :project, to: :ticket
  scope :persisted, lambda { where.not(id: nil) }
  def set_ticket_state
	ticket.state = self.state
	ticket.save!
  end
  def set_previous_state
  	self.previous_state = ticket.state
  end
end
