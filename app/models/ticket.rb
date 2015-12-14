class Ticket < ActiveRecord::Base
  belongs_to :project
  belongs_to :author, class_name: "User"
  belongs_to :state
  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 75 }
  has_many :comments, dependent: :destroy
end
