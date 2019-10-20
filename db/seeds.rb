user = User.create!(
  account_id: 'kthatoto',
  password: 'password',
  token_digest: Digest::SHA1.hexdigest('token_kthatoto'),
)

template = RoutineTemplate.create!(
  user_id: user.id,
  name: '掃除する',
  description: 'どこか掃除をする',
  start_date: Date.today,
  target_count: nil,
)
