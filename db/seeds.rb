user = User.create!(email: 'kthatoto@gmail.com')

template = RoutineTemplate.create!(
  user_id: user.id,
  name: '掃除する',
  description: 'どこか掃除をする',
  interval_type: :daily,
  start_date: Date.today,
  target_count: nil,
)
