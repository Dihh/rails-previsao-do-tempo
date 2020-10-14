require 'net/http'
require 'json'
require 'date'

class PrevisaoController < ApplicationController
  ICONS = {
    '01d' => 'fas fa-sun',
    '01n' => 'fas fa-moon',

    '02d' => 'fas fa-cloud-sun',
    '02n' => 'fas fa-cloud-moon',

    '03d' => 'fas fa-cloud',
    '03n' => 'fas fa-cloud',

    '04d' => 'fas fa-cloud',
    '04n' => 'fas fa-cloud',

    '09d' => 'fas fa-cloud-rain',
    '09n' => 'fas fa-cloud-rain',

    '10d' => 'fas fa-cloud-sun-rain',
    '10n' => 'fas fa-cloud-moon-rain',

    '11d' => 'fas fa-cloud-showers-heavy',
    '11n' => 'fas fa-cloud-showers-heavy',

    '13d' => 'fas fa-snowflake',
    '13n' => 'fas fa-snowflake',

    '50d' => 'fas fa-cloud',
    '50n' => 'fas fa-cloud'
  }.freeze

  DAYS = {
    0 => 'Dom',
    1 => 'Seg',
    2 => 'Ter',
    3 => 'Qua',
    4 => 'Qui',
    5 => 'Sex',
    6 => 'Sab'
  }.freeze

  OPENWEATHER_APPID = ENV['OPENWEATHER_APPID']
  GOOGLE_API_KEY = ENV['GOOGLE_API_KEY']

  def index
    if params[:city]
      address = params[:city] || 'Belo Horizonte'
      @user_location = params[:city]
      uri = URI("https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{GOOGLE_API_KEY}")
      res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new uri
        http.request request
      end
      @addr = JSON.parse(res.body)
      # puts JSON.pretty_generate(@addr)
      lat = @addr['results'][0]['geometry']['location']['lat']
      lon = @addr['results'][0]['geometry']['location']['lng']
      @addr = JSON.parse(res.body)
      @location = @addr['results'][0]['address_components'].map do |el|
        el['short_name']
      end
      @location = @location[1..2].join(' ')
      # puts JSON.pretty_generate(@addr)
    elsif params[:lat] && params[:long]
      @user_location = [params[:lat], params[:long]]
      lat = params[:lat]
      lon = params[:long]

      uri = URI("https://maps.googleapis.com/maps/api/geocode/json?latlng=#{lat},#{lon}&key=#{GOOGLE_API_KEY}")
      res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new uri
        http.request request
      end
      @addr = JSON.parse(res.body)
      @location = @addr['results'][0]['address_components'].map do |el|
        el['short_name']
      end
      @location = @location[0..2].join(' ')
      # puts JSON.pretty_generate(@addr)
    else
      @user_location = nil
      return
    end

    uri = URI("http://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&appid=#{OPENWEATHER_APPID}&lang=pt_br&units=metric")

    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri
      http.request request
    end
    @previsao = JSON.parse(res.body)
    @previsao['time'] = Time.zone.at(@previsao['dt'] + @previsao['timezone']).to_s
    @previsao['time'] = @previsao['time'].split(' ')[1][0..-4]
    # puts JSON.pretty_generate(@previsao)

    uri = URI("https://api.openweathermap.org/data/2.5/forecast?lat=#{lat}&lon=#{lon}&appid=#{OPENWEATHER_APPID}&lang=pt_br&units=metric")
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri
      http.request request
    end

    forecast = JSON.parse(res.body)

    @days = (0..forecast['list'].length - 1).step(8).map do |index|
      forecast['list'][index]['time'] = Time.zone.at(forecast['list'][index]['dt'] + forecast['city']['timezone'])
      forecast['list'][index]['day_name'] = DAYS[forecast['list'][index]['time'].wday]
      forecast['list'][index]['icon'] = ICONS[forecast['list'][index]['weather'][0]['icon']]
      forecast['list'][index]
    end

    @hours = (0..5).step(1).map do |index|
      forecast['list'][index]['time'] = Time.zone.at(forecast['list'][index]['dt'] + forecast['city']['timezone'])
      forecast['list'][index]['time'] = forecast['list'][index]['time'].to_s.split(' ')[1][0..-4]
      forecast['list'][index]
    end

    @line_chart_hours = @hours.map do |hour|
      [hour['time'], hour['main']['temp'].round(0)]
    end
  end
end
