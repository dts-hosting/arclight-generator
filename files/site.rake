namespace :site do
  task setup: :environment do
    site = ENV.fetch("ARCLIGHT_SITE")

    FileUtils.cp(
      Rails.root.join("sites", site, "repositories.yml"),
      Rails.root.join("config", "repositories.yml")
    )

    FileUtils.cp(
      Rails.root.join("sites", site, "downloads.yml"),
      Rails.root.join("config", "downloads.yml")
    )

    FileUtils.cp(
      Rails.root.join("sites", site, "index.html.erb"),
      Rails.root.join("app", "views", "static", "index.html.erb")
    )

    FileUtils.cp(
      Rails.root.join("sites", site, "locales.yml"),
      Rails.root.join("config", "locales", "en.yml")
    )

    FileUtils.cp(
      Rails.root.join("sites", site, "styles.css"),
      Rails.root.join("public", "styles.css")
    )

    logo_path = File.join("sites", site, "logo.png")
    if File.exist?(logo_path)
      FileUtils.cp(logo_path, File.join("app", "assets", "images", "logo.png"))
      FileUtils.cp(logo_path, File.join("public", "logo.png"))
    end
  end
end
