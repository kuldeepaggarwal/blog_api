require_relative './admin_seeder'

[AdminSeeder].each(&:seed!)
