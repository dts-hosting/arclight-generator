require_relative "arclight_helpers"
require "yaml"

config = YAML.safe_load_file(File.join(__dir__, "config", "arclight.yml"))

gem "arclight", :github => config["repository"], config["version_type"].to_sym => config["version_ref"]

gem_group :development, :test do
  gem "standard"
  gem "standard-rails"
end

process_file_operations(config["operations"])

run "bundle"

after_bundle do
  in_root do
    generate "blacklight:install"
    generate "arclight:install", "-f"
    rails_command "db:migrate"
  end

  run "bundle remove solr_wrapper"
  run "bundle exec standardrb --fix-unsafely"

  git :init
  git add: "."
  git commit: "-a -m 'Initial commit'"

  say "Job done! 🎉", :green
end
