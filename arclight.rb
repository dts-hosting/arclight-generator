require_relative "arclight_helpers"
require "yaml"

config = YAML.safe_load_file(File.join(__dir__, "config", "arclight.yml"))

gem "arclight", :github => config["repository"], config["version_type"].to_sym => config["version_ref"]

gem_group :development, :test do
  gem "standard"
  gem "standard-rails"
end

run "bundle"

after_bundle do
  empty_directory "app/components/arclight"
  empty_directory "app/views/shared"
  empty_directory "app/views/static"
  directory File.join(__dir__, "config", "sites"), "sites", force: true

  in_root do
    generate "blacklight:install"
    generate "arclight:install", "-f"
    rails_command "db:migrate"
  end

  process_file_operations(config["operations"])

  run "bundle remove solr_wrapper"
  run "bundle exec standardrb --fix-unsafely"

  git :init
  git add: "."
  git commit: "-a -m 'Init: #{Time.now.utc}'"

  say "Job done! 🎉", :green
end
