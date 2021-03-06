require_relative 'lib/tiktok_scraper/version'

Gem::Specification.new do |spec|
  spec.name          = "tiktok_scraper"
  spec.version       = TiktokScraper::VERSION
  spec.authors       = ["Lord Meidar"]
  spec.email         = ["elad@shinobidevs.com"]

  spec.summary       = "Scraping tiktok"
  spec.description   = "Scraping tiktok"
  spec.homepage      = "https://github.com/eladmeidar"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/eladmeidar/tiktok_scraper"
  spec.metadata["changelog_uri"] = "https://github.com/eladmeidar/tiktok_scraper"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'httparty'
  spec.add_dependency 'rack'
  spec.add_dependency 'user-agent-randomizer'
  spec.add_development_dependency 'byebug'
end
