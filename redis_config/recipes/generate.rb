node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]
  # determine root folder of new app deployment
  # app_root = "#{deploy_config[:deploy_to]}/current"

  # use template 'redis.yml.erb' to generate 'config/redis.yml'
  template "#{deploy[:deploy_to]}/shared/config/redis.yml" do
    source "redis.yml.erb"
    cookbook "redis_config"

    # set mode, group and owner of generated file
    mode "0660"
    group deploy[:group]
    owner deploy[:user]

    # define variable “@redis” to be used in the ERB template
    variables(:redis => deploy[:redis], :environment => deploy[:rails_env])

    # notifies :run, "execute[restart Rails app #{application}]"

    # only generate a file if there is Redis configuration
    only_if do
      deploy[:redis].present? && File.directory?("#{deploy[:deploy_to]}/shared/config/")
    end
  end
end
