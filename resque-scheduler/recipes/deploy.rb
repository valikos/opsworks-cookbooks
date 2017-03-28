node[:deploy].each do |application, deploy|
  next unless deploy[:application_type] == "rails"

  execute "monit restart resque-scheduler_#{application}" do
    action :run
  end
end
