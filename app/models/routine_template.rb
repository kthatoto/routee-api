class RoutineTemplate < ApplicationRecord

  validates :name, presence: true
  validates :start_date, presence: true

  def self.get_by_date(user_id, date)
    RoutineTemplate.where(
      'archived = false AND user_id = ? AND start_date <= ?',
      user_id,
      date,
    )
  end
end
