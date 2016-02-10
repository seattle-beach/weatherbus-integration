require 'net/http'
require 'json'
require './Config'

describe '/api/v1/stops' do
  it 'should return correct JSON for a stop that exists' do
    uri = URI("#{Config.base_services_url}/api/v1/stops/1_619")
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(Net::HTTP::Get.new(uri.request_uri))
    expect(response.code).to eq('200')
    expect(response['content-type']).to start_with('application/json')
    data = JSON.parse(response.body)['data']
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
