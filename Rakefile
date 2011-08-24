$LOAD_PATH << File.dirname(__FILE__) + "/lib"
require 'boot'
require 'pathname'

Bundler.require

desc "Runs the app using shotgun"
task :run do
  sh "shotgun"
end

task :db do
  DB = Sequel.connect('sqlite://db/development.sqlite')
end

namespace :db do
  desc "Runs the migrations"
  task :migrate => :db do
    require 'sequel/extensions/migration'
    Sequel::Migrator.apply(DB, 'db/migrations')
  end

  desc "Generates a migration with the given name"
  task :migration, :name do |t, args|
    require 'sequel/extensions/inflector'
    require 'facets/string/margin'
    args.with_defaults(:name => "thing")
    table_name = args[:name].pluralize
    timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
    migration = Pathname.new("db/migrations/#{timestamp}_#{table_name}.rb")
    migration.dirname.mkpath
    migration.open('w+') do |f|
      f << <<-RUBY.margin
        |Sequel.migration do
        |  up do
        |    create_table(:#{table_name}) do
        |      primary_key :id
        |    end
        |  end
        |  down do
        |    drop_table(:#{table_name})
        |  end
        |end
      RUBY
    end
  end
end
