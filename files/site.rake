namespace :site do
  task setup: :environment do
    site = ENV.fetch("ARCLIGHT_SITE")

    FileUtils.cp(
      Rails.root.join("sites", site, "repositories.yml"),
      Rails.root.join("config", "repositories.yml")
    )

    FileUtils.cp(
      Rails.root.join("sites", site, "locales.yml"),
      Rails.root.join("config", "locales", "en.yml")
    )

    FileUtils.cp(
      Rails.root.join("sites", site, "styles.css"),
      Rails.root.join("public", "styles.css")
    )
  end
end
