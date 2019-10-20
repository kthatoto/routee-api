class RoutineSerializer < ActiveModel::Serializer
  attributes :id
  attributes :count
  attributes :achieved
  attributes :name
  attributes :description
  attributes :target_count

  def target_count
    [nil, 0, 1].include?(object.target_count) ? nil : object.target_count
  end
end
