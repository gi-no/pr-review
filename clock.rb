require './pr_police'
require 'business_time'
require 'clockwork'

include Clockwork


return unless Date.today.workday?

every(1.hour, 'job', at: ['12:00', '15:00', '18:00z']) do
  PrPolice.new.notify
end
