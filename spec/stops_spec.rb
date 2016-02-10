require 'net/http'
require 'json'
require './Config'

def get(uri)
  http = Net::HTTP.new(uri.host, uri.port)
  http.request(Net::HTTP::Get.new(uri.request_uri))
end

def get_json(uri)
  response = get(uri)
  expect(response.code).to eq('200')
  expect(response['content-type']).to start_with('application/json')
  JSON.parse(response.body)
end

describe '/api/v1/stops/{stop ID}' do
  it 'should return correct JSON for a stop that exists' do
    data = get_json(URI("#{Config.base_services_url}/api/v1/stops/1_619"))['data']
    expect(-90..90).to cover(data['latitude'])
    expect(-180..180).to cover(data['longitude'])
    expect(data['stopId']).to eq('1_619')
    expect(data['departures']).to be_instance_of(Array)

    # This is a buys enough stop around the clock that there should always be departures.
    expect(data['departures'].length).to_not eq(0)
    data['departures'].each do |departure|
      expect(departure['climacon_url']).to start_with('http://weatherbus-weather-dev.cfapps.io/assets')
      expect(departure['climacon']).to be_instance_of(String)
      expect(departure['routeShortName']).to be_instance_of(String)
      expect(departure['headsign']).to be_instance_of(String)

      expect(departure['temp']).to be_instance_of(Float)
      expect(departure['predictedTime']).to be_instance_of(Fixnum)
      expect(departure['scheduledTime']).to be_instance_of(Fixnum)
    end
  end
end

describe '/api/vi/stops/?{lat, lng, etc}' do
  it 'should return a list of nearby stops' do
    data = get_json(URI("#{Config.base_services_url}/api/v1/stops/?lat=47.599&lng=-122.3341&latSpan=0.0172&lngSpan=0.0148"))['data']
    expect(data).to be_instance_of(Array)
    # Lots of stops around here, should never be 0
    expect(data.length).to_not eq(0)
    data.each do |stop|
      expect(stop['id']).to be_instance_of(String)
      expect(stop['name']).to be_instance_of(String)
      expect(-90..90).to cover(stop['latitude'])
      expect(-180..180).to cover(stop['longitude'])
    end
  end
end
