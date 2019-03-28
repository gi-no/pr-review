require './slack_users'
require 'active_support'
require 'active_support/core_ext'
require 'dotenv'
require 'faraday'
require 'json'
require 'slack/incoming/webhooks'

Dotenv.load


class PrPolice
	URL = "https://api.github.com/repos/#{ ENV["OWNER"] }/#{ ENV["REPOSITORY"] }/pulls?access_token=#{ ENV["ACCESS_TOKEN"] }&state=open"

	def notify
		puts URL
		res = Faraday.get(URL)
		res_json = JSON.parse(res.body)
		results = res_json.select { |res| res['requested_reviewers'].present? }
		return if results.empty?

		results.each do |result|
			next if wip?(result)
			next if pending?(result)

			txt = notification_text(result)
			notify_to_slack(txt)
		end
	rescue => ex
		notify_to_slack("エラーです\n#{ ex }")
	end

	private

	def notify_to_slack(text)
		slack = Slack::Incoming::Webhooks.new(ENV["WEBHOOK_URL"])
		slack.post(text)
	end

	def notification_text(json)
		<<~EOS
			#{ requested_reviewers(json) }
			レビューよろしくお願いします。
			#{ json['html_url'] }
		EOS
	end

	def requested_reviewers(json)
		json['requested_reviewers']
			.map { |j| "<@#{ SLACK_USERS[j['login'].to_sym] }>" }
			.join(', ')
	end

	def pending?(json)
		results = json['labels'].map do |label|
			label.has_value?('pending')
		end

		results.include?(true)
	end

	def wip?(json)
		json['title'].start_with?('[WIP]')
	end
end
