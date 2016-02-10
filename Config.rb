class Config
  def self.svcenv
   ENV['svcenv'] or "dev"
  end

  def self.appenv
   ENV['appenv'] or "dev"
  end

  def self.base_services_url
    case svcenv
    when "staging"
      "http://weatherbus-prime-staging.cfapps.io/"
    when "dev"
      "http://weatherbus-prime-dev.cfapps.io/"
    when "local"
      "http://localhost:8080/"
    else
      raise "No service URL configured for the \"#{svcenv}\" environment"
    end
  end

  def self.app_url
    case appenv
    when "staging"
      "http://weatherbus-web-staging.cfapps.io/"
    when "dev"
      "http://weatherbus-web-dev.cfapps.io/"
    when "local"
      "http://localhost:8000/"
    else
      raise "No app URL configured for the \"#{appenv}\" environment"
    end
  end

  def self.climacon_base_url
    case appenv
    when "staging"
      "http://weatherbus-weather-staging.cfapps.io/"
    when "dev"
      "http://weatherbus-weather-dev.cfapps.io/"
    when "local"
      "http://localhost:8080/"
    else
      raise "No app URL configured for the \"#{appenv}\" environment"
    end
  end
end
