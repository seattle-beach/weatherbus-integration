require 'net/http'
require 'json'
require 'capybara/rspec'
require 'capybara/poltergeist'
require './Config'


# Username is arbitrary but the stop ID and coordinates need to match up
# with actual One Bus Away data.
USERNAME = 'integration'
STOP_ID = '1_75403'
STOP_NAME = 'Stevens Way & Benton Ln'
LATITUDE = '47.654'
LONGITUDE = '-122.305'


def post_json(uri, body)
  http = Net::HTTP.new(uri.host, uri.port)
  return http.post(uri, body, {'Content-type' => 'application/json'})
end

def add_user(username)
  uri = URI("#{Config.base_services_url}/users")
  response = post_json(uri, "{\"username\": \"#{username}\"}")

  if response.code != '200'
    doc = JSON.parse(response.body)
    if doc['message'] != "User already exists"
      raise "Failed to add user; HTTP code #{response.code}, message \"#{doc['message']}\""
    end
  end
end

def add_stop(username, stop_id)
  uri = URI("#{Config.base_services_url}/users/#{username}/stops")
  response = post_json(uri, "{\"stopId\": \"#{stop_id}\"}")

  if response.code != '200'
    raise "Failed to add user; HTTP code #{response.code}, body \"#{response.body}\""
  end
end


describe 'Weatherbus web front-end integration', :type => :feature do
  it 'should work' do
    headless = true # Change to false to debug in a real browser

    if headless
      Capybara.default_driver = :poltergeist
      Capybara.javascript_driver = :poltergeist
    else
      Capybara.default_driver = :selenium
    end

    add_user(USERNAME)
    add_stop(USERNAME, STOP_ID)
    path = File.expand_path(Dir.pwd + "/../target/index.html")

    visit(Config.app_url)
    click_link('Log in')
    fill_in 'username', :with => USERNAME
    click_button('Go')
    expect(page).to have_content STOP_NAME
    click_link(STOP_NAME)
    expect(page).to have_content "Latitude: #{LATITUDE}"
    expect(page).to have_content "Longitude: #{LONGITUDE}"
  end
end
