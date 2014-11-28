require "bundler/gem_tasks"

task :test do
  arg_files = ENV["FILES"] && ENV["FILES"].split(/[\s,]+/)
  all_files = Rake::FileList["./spec/**/*_spec.rb"]
  files = arg_files || all_files
  puts "\nRuning tests for: #{ files.join(" ") }\n\n"

  system *["matest"].concat(files)
end

task :default => :test
