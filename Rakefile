task default: :spec

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :setup do
  unless system('phantomjs -h > /dev/null 2>&1')
    sh 'npm install -g phantomjs'
  end
end
