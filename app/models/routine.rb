class Routine < ApplicationRecord

  belongs_to :routine_template
  belongs_to :routine_term

  validates :user_id, presence: true
  validates :routine_template_id, presence: true
  validates :routine_term_id, presence: true

  delegate :name, :description, :target_count, to: :routine_template
end
