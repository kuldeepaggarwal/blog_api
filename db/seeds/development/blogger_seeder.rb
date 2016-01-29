class BloggerSeeder
  def self.seed!
    User.blogger.where(email: 'kd.engineer@yahoo.co.in')
        .first_or_create!({
          first_name: 'Kuldeep',
          last_name: 'Aggarwal',
          password: 'test123',
          password_confirmation: 'test123'
        })
  end
end
