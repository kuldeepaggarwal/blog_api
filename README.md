## Blog API

It is a blog api where a user can create blogs and can comment on it. For the
security concerns we have different roles of a user.

### Roles of a User
- Admin: He is the one who have the authority to manage everything in the system. He can create users/blogs/comments.
- Blogger: This user can create blogs/comments and edit/update his/her own blogs/ comments.
- Guest: Any user who is not logged in will be treated as `Guest` user and he/she will be allowed to see only blogs present in the system.

### Prerequisite

* Ruby > 2.2.x

### Steps to setup

1. Clone the repo using `git clone git@github.com:kuldeepaggarwal/blog_api.git`
2. Checkout to `development` branch as this is upto date branch
3. Run `bundle install`.
4. Create configuration files from their respective `.example` files in config folder. For Example: copy `database.yml.example` into `database.yml`
5. Create database using `rake db:create` command
6. Run any migrations using `rake db:migrate` command
7. Run the seeds for the project using `rake db:seed` command
8. Run Rails Server using `rails s` command

### Concept of seed

We have new approach to seed data per environment.

For this, we can create <environment> specific file, where `environment` can be any valid rails environment, like: `development`, `test`, `production` and so on, in `db/seeds` folder. Apart from this we have a special file `db/seeds/all.rb` where we can put seed data that will be common to all environment.

<pre>|___seeds
| |___all.rb
| |___development.rb
| |___staging.rb
| |___production.rb
|___seeds.rb
</pre>

### Testing

```shell
$ cd [path-to-project]
$ bundle install
$ RAILS_ENV=test bundle exec rake db:create db:migrate db:seed
$ RAILS_ENV=test bundle exec rake spec
```

### Enhancements

1. We should have the ability to create nested comments.
2. All the permissions are hard coded, we should have a mechanism that an admin can give permissions to any user. Granular level permissions.
3. We don't have feature to create roles dynamically.
