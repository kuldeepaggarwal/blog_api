require_relative './admin_seeder'
require_relative './development/blogger_seeder'
require_relative './development/blog_seeder'
require_relative './development/comment_seeder'

[AdminSeeder, BloggerSeeder, BlogSeeder, CommentSeeder].each(&:seed!)
