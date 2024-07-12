require "sinatra"
require "sinatra/reloader"
require "http"

get("/") do
  @currencies = get_currency_list

  erb(:root)
end

get("/:from_currency") do
  @currencies = get_currency_list
  @from = params.fetch("from_currency")

  erb(:currency)
end

get("/:from_currency/:to_currency") do
  @from = params.fetch("from_currency")
  @to = params.fetch("to_currency")

  rate_url = "https://api.exchangerate.host/convert?from=#{@from}&to=#{@to}&amount=1&access_key=#{ENV.fetch("KEY")}"

  @rate = JSON.parse(HTTP.get(rate_url).to_s).fetch("result")
  erb(:result)
end

def get_currency_list
  currencies_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("KEY")}"

  response = JSON.parse(HTTP.get(currencies_url).to_s)
  return response.fetch("currencies").keys
end
