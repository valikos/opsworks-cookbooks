node[:deploy].each do |application, deploy|
  next unless deploy[:application_type] == "rails"

  execute "monit restart resque-pool_#{application}" do
    action :run
  end
end
