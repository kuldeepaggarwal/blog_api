class AdminSeeder
  def self.seed!
    User.admin.where(email: 'admin@blog-api.com')
        .first_or_create!({
          first_name: 'Admin',
          password: 'test123',
          password_confirmation: 'test123'
        })
  end
end

