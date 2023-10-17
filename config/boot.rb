ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

# railsコンソールのエラーを解消する一文（ChatGPTに教えてもらった）
ENV['OBJC_DISABLE_INITIALIZE_FORK_SAFETY'] = 'YES'
