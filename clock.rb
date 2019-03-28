require './pr_police'
require 'business_time'
require 'clockwork'
require 'dotenv'

include Clockwork
Dotenv.load


return unless Date.today.workday?

every(1.minutes, 'job') do
  URL = "https://api.github.com/repos/#{ ENV["OWNER"] }/#{ ENV["REPOSITORY"] }/pulls?access_token=#{ ENV["ACCESS_TOKEN"] }&state=open"
  puts URL
  PrPolice.new.notify
end
