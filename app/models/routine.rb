class Routine < ApplicationRecord

  belongs_to :routine_template
  belongs_to :routine_term

  validates :user_id, presence: true
  validates :routine_template_id, presence: true
  validates :routine_term_id, presence: true

  delegate :name, to: :routine_template
  delegate :description, to: :routine_template
  delegate :target_count, to: :routine_template
  delegate :single_count? , to: :routine_template

  def decrementable?
    !single_count? && count > 0
  end

  def increment_count!
    return if single_count?
    increment!(:count)
    if !achieved && target_count <= count
      update(achieved: true)
    end
  end

  def decrement_count!
    return unless decrementable?
    decrement!(:count)
    if achieved && count < target_count
      update(achieved: false)
    end
  end
end
