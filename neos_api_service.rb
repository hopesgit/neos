class NEOSApiService
  def get_near_miss_info(date, key)
    conn = Faraday.new(
      url: 'https://api.nasa.gov',
      params: { start_date: date, api_key: key}
    )

    response = conn.get('/neo/rest/v1/feed')

    JSON.parse(response.body, symbolize_names: true)[:near_earth_objects][:"#{date}"]
  end
end
