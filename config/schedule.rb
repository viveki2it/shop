# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

env :PATH, ENV['PATH']
every 1.hours do
	command "cd /home/deploy/apps/som_production_ldn/current/ && bundle exec rake environment daily_scraper:queue_it_up RAILS_ENV=production >> log/cron_tests.log"
  #rake 'daily_scraper:tell_ben_its_working'
end

# clean out temp, otherwise it baloons with temporary
# files from scraping
every :day, :at => '12:00pm' do
  command "tmpreaper --showdeleted 1d /tmp"
end

#every :day, :at => '9:00am' do
  #rake "email:data_integrity_report"
#end
