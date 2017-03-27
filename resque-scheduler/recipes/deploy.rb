node[:deploy].each do |application, deploy|
  next unless deploy[:application_type] == "rails"

  service "resque-scheduler_#{application}" do
    action :restart
  end
end
