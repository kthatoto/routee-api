User.create!(
  account_id: 'kthatoto',
  password: 'password',
  token_digest: Digest::SHA1.hexdigest('token_kthatoto'),
)
