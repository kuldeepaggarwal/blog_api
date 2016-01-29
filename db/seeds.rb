['all', Rails.env].each do |file_name|
  seed_file = Rails.root.join('db', 'seeds', "#{ file_name }.rb")
  if File.exists?(seed_file)
    puts "*** Loading #{ file_name } seed data"
    require seed_file
  end
end
