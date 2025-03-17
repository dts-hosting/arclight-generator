namespace :arclight do
  task :run do
    Bundler.with_clean_env do
      Dir.chdir(File.join(__dir__, "arclight")) do
        system("./bin/dev")
      end
    end
  end
end

namespace :site do
  task :copy, [:site] do |_t, args|
    FileUtils.cp(
      File.join(__dir__, "config", "sites", args[:site], "repositories.yml"),
      File.join(__dir__, "arclight", "config", "repositories.yml")
    )

    FileUtils.cp(
      File.join(__dir__, "config", "sites", args[:site], "locales.yml"),
      File.join(__dir__, "arclight", "config", "locales", "en.yml")
    )

    FileUtils.cp(
      File.join(__dir__, "config", "sites", args[:site], "styles.css"),
      File.join(__dir__, "arclight", "public", "styles.css")
    )
  end

  task :init, [:site] do |_t, args|
    FileUtils.mkdir_p(File.join(__dir__, "config", "sites", args[:site]))
    FileUtils.touch(File.join(__dir__, "config", "sites", args[:site], "repositories.yml"))
    FileUtils.touch(File.join(__dir__, "config", "sites", args[:site], "locales.yml"))
    FileUtils.touch(File.join(__dir__, "config", "sites", args[:site], "styles.css"))
  end

  task :sync do
    FileUtils.cp_r(
      File.join(__dir__, "config", "sites"),
      File.join(__dir__, "arclight", "sites")
    )
  end
end
