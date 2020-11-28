require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative 'near_earth_objects'

class NearEarthObjectsTest < Minitest::Test
  def setup
    @info = NEOSApiService.new.get_near_miss_info('2019-03-30', '7MtElCfYeYfeWUbDbpHhi7aDg4Oupzb9JVec4glu')
  end

  def test_a_date_returns_a_list_of_neos
    results = NearEarthObjects.find_neos_by_date('2019-03-30')

    assert_equal '(2011 GE3)', results[:asteroid_list][0][:name]
  end

  def test_it_can_get_largest_asteroid_diameter
    setup = NearEarthObjects.find_largest_asteroid_diameter(@info)
    assert_equal 537, setup
  end

  def test_it_can_get_number_of_neos_on_given_date
    setup = NearEarthObjects.total_number_of_asteroids(@info)
    assert_equal 10, setup
  end

  def test_it_can_format_asteroid_data
    setup = NearEarthObjects.formatted_asteroid_data(@info)
    test = setup.all? do |asteroid|
      !asteroid[:name].nil?
      asteroid[:name].is_a?(String)
      !asteroid[:diameter].nil?
      asteroid[:diameter].is_a?(Integer)
      !asteroid[:miss_distance].nil?
      asteroid[:miss_distance].is_a?(Integer)
    end
    assert test
  end
end
