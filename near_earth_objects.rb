require 'faraday'
require 'figaro'
require 'pry'
require_relative 'neos_api_service'
# Load ENV vars via Figaro
Figaro.application = Figaro::Application.new(environment: 'production', path: File.expand_path('../config/application.yml', __FILE__))
Figaro.load

class NearEarthObjects
  def self.find_neos_by_date(date)
    asteroid_data = NEOSApiService.new.get_near_miss_info(date, ENV['nasa_api_key'])

    # conn = Faraday.new(
    #   url: 'https://api.nasa.gov',
    #   params: { start_date: date, api_key: ENV['nasa_api_key']}
    # )
    # asteroids_list_data = conn.get('/neo/rest/v1/feed')

    # parsed_asteroids_data = JSON.parse(asteroids_list_data.body, symbolize_names: true)[:near_earth_objects][:"#{date}"]

    # largest_asteroid_diameter = asteroid_data.map do |asteroid|
    #   asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i
    # end.max { |a,b| a<=> b}

    # total_number_of_asteroids = asteroid_data.count

    # formatted_asteroid_data = asteroid_data.map do |asteroid|
    #   {
    #     name: asteroid[:name],
    #     diameter: "#{asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i} ft",
    #     miss_distance: "#{asteroid[:close_approach_data][0][:miss_distance][:miles].to_i} miles"
    #   }
    # end

    {
      asteroid_list: self.formatted_asteroid_data(asteroid_data),
      biggest_asteroid: self.find_largest_asteroid_diameter(asteroid_data),
      total_number_of_asteroids: self.total_number_of_asteroids(asteroid_data)
    }
  end

  def self.find_largest_asteroid_diameter(asteroid_data)
    largest_asteroid = asteroid_data.max_by do |asteroid|
      asteroid[:estimated_diameter][:feet][:estimated_diameter_max]
    end

    largest_asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i
  end

  def self.total_number_of_asteroids(asteroid_data)
    asteroid_data.count
  end

  def self.formatted_asteroid_data(asteroid_data)
    asteroid_data.map do |asteroid|
      {
      name: asteroid[:name],
      diameter: asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i,
      miss_distance: asteroid[:close_approach_data][0][:miss_distance][:miles].to_i
      }
    end
  end
end
