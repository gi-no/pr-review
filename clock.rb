require './pr_police'
require 'business_time'
require 'clockwork'

include Clockwork


return unless Date.today.workday?

every(1.minutes, 'job') do
  PrPolice.new.notify
end
