class CommentSeeder
  def self.seed!
    Blog.all.each do |blog|
      if blog.comments.none?
        User.all.each do |user|
          blog.comments.create(creator: user, text: 'Add a sample comment')
        end
      end
    end
  end
end
