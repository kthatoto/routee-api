class RoutineSerializer < ActiveModel::Serializer
  attributes :id
  attributes :count
  attributes :achieved
  attributes :name
  attributes :description
  attributes :target_count
end
