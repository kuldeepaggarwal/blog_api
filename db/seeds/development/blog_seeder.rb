class BlogSeeder
  def self.seed!
    User.all.each do |user|
      user.blogs.create({
        title: 'My First Blog',
        description: 'This is my first blog.'
      }) if user.blogs.none?
    end
  end
end
