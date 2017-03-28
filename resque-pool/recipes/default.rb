node[:deploy].each do |application, deploy|
  next unless deploy[:application_type] == "rails"

  environment_variables =
    OpsWorks::Escape.escape_double_quotes(deploy[:environment_variables])
    .merge('RAILS_ENV' => deploy[:rails_env])

  # template "/etc/init.d/resque-pool_#{application}" do
  #   source "resque-pool.init.erb"
  #   owner "root"
  #   group "root"
  #   mode "0755"
  #   variables(
  #     :application => application,
  #     :current_path => deploy[:current_path],
  #     :app_path => deploy[:deploy_to],
  #     :environment => environment_variables
  #   )
  # end

  template ::File.join(node[:monit][:conf_dir], "resque-pool_#{application}.monitrc") do
    source "resque-pool.monit.erb"
    owner "root"
    group "root"
    mode "0644"
    variables(
      :application => application,
      :current_path => deploy[:current_path],
      :environment => environment_variables
    )
  end

  execute "monit reload" do
    action :run
  end

  # service "resque-pool_#{application}" do
  #   service_name "resque-pool_#{application}"
  #   supports :start => true, :reload => true, :stop => true, :restart => true
  #   action [:enable, :start]
  # end
end
