task default: :spec

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :setup do
  unless system('phantomjs -h > /dev/null 2>&1')
    sh 'npm install -g phantomjs'
  end
end

task :deploy do
  require 'json'
  require 'open-uri'
  require 'yaml'

  repos = %w[ weatherbus-bus weatherbus-weather weatherbus weatherbus-web ].each.with_object({}) do |repo, repos|
    builds = JSON.load(open("https://api.travis-ci.org/repos/seattle-beach/#{repo}/builds").read)
    successes = builds.select { |build| build['state'] == 'finished' && build['result'] && build['result'].zero? }
    repos[repo] = successes.first
  end

  puts 'Deploying the following commits:'
  repos.each do |repo, build|
    name = repo.ljust(repos.keys.map(&:size).max)
    puts "#{name} (#{build['commit'][0, 8]}): #{build['message']}"
  end
  print 'Continue? [y/N] '
  exit unless STDIN.gets.chomp.downcase == 'y'

  space = ENV.fetch('DEPLOY_SPACE', 'weatherbus-staging')
  with_space(space) do
    repos.each do |repo, build|
      cd "modules/#{repo}" do
        sh "git fetch && git checkout #{build['commit']}"
        manifest = YAML.load_file('manifest.yml')
        hostname = manifest['applications'][0]['host'].sub('dev', 'staging')
        sh "cf push --hostname=#{hostname}"
      end
    end
  end
end

def with_space(space)
  target = `cf target`
  original_space = target[/^Space:\s*([^\s]+)\s*$/, 1]
  sh "cf target -s #{space}"

  yield
ensure
  sh "cf target -s #{original_space}"
end
