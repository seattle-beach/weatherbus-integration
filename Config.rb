class Config
  def self.svcenv
   ENV['svcenv'] or "acceptance"
  end

  def self.appenv
   ENV['appenv'] or "acceptance"
  end

  def self.base_services_url
    case svcenv
    when "acceptance"
      "http://weatherbus-prime-dev.cfapps.io/"
    when "local"
      "http://localhost:8080/"
    else
      raise "No service URL configured for the \"#{svcenv}\" environment"
    end
  end

  def self.app_url
    case appenv
    when "acceptance"
      "http://weatherbus-web-dev.cfapps.io/"
    when "local"
      "http://localhost:8000/"
    else
      raise "No app URL configured for the \"#{appenv}\" environment"
    end
  end
end
