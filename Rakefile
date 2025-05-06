require "net/http"
require "uri"
require "json"

SOLR_URL = "http://localhost:8983/solr/arclight"

namespace :arclight do
  task :build do
    Rake::Task["site:sync"].invoke
    Dir.chdir(File.join(__dir__, "arclight")) do
      system("docker compose -f docker-compose-qa.yml build")
    end
  end

  task :dev do
    Bundler.with_clean_env do
      Dir.chdir(File.join(__dir__, "arclight")) do
        system("SOLR_URL=#{SOLR_URL} ./bin/dev")
      end
    end
  end

  task :qa do
    Dir.chdir(File.join(__dir__, "arclight")) do
      system("docker compose -f docker-compose-qa.yml up")
    end
  end

  task :reset do
    solr_url = "#{SOLR_URL}/update?commit=true"
    uri = URI.parse(solr_url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, {"Content-Type" => "text/xml"})
    request.body = "<delete><query>*:*</query></delete>"
    response = http.request(request) # make the delete request
    puts "Response Code: #{response.code}"
    puts "Response Body: #{response.body}"
  end
end

namespace :site do
  task :copy, [:site] do |_t, args|
    FileUtils.cp(
      File.join(__dir__, "config", "sites", args[:site], "repositories.yml"),
      File.join(__dir__, "arclight", "config", "repositories.yml")
    )

    FileUtils.cp(
      File.join(__dir__, "config", "sites", args[:site], "downloads.yml"),
      File.join(__dir__, "arclight", "config", "downloads.yml")
    )

    FileUtils.cp(
      File.join(__dir__, "config", "sites", args[:site], "index.html.erb"),
      File.join(__dir__, "arclight", "app", "views", "static", "index.html.erb")
    )

    FileUtils.cp(
      File.join(__dir__, "config", "sites", args[:site], "locales.yml"),
      File.join(__dir__, "arclight", "config", "locales", "en.yml")
    )

    FileUtils.cp(
      File.join(__dir__, "config", "sites", args[:site], "styles.css"),
      File.join(__dir__, "arclight", "public", "styles.css")
    )

    logo_path = File.join(__dir__, "config", "sites", args[:site], "logo.png")
    if File.exist?(logo_path)
      FileUtils.cp(logo_path, File.join(__dir__, "arclight", "app", "assets", "images", "logo.png"))
      FileUtils.cp(logo_path, File.join(__dir__, "arclight", "public", "logo.png"))
    end
  end

  task :init, [:site] do |_t, args|
    FileUtils.mkdir_p(File.join(__dir__, "config", "sites", args[:site]))
    FileUtils.touch(File.join(__dir__, "config", "sites", args[:site], "repositories.yml"))
    FileUtils.touch(File.join(__dir__, "config", "sites", args[:site], "downloads.yml"))
    FileUtils.touch(File.join(__dir__, "config", "sites", args[:site], "index.html.erb"))
    FileUtils.touch(File.join(__dir__, "config", "sites", args[:site], "locales.yml"))
    FileUtils.touch(File.join(__dir__, "config", "sites", args[:site], "styles.css"))
  end

  task :sync do
    FileUtils.cp_r(
      File.join(__dir__, "config", "sites"),
      File.join(__dir__, "arclight")
    )
  end
end
