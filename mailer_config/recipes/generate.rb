node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]
  # determine root folder of new app deployment
  # app_root = "#{deploy_config[:deploy_to]}/current"

  # use template 'mailer.yml.erb' to generate 'config/mailer.yml'
  template "#{deploy[:deploy_to]}/shared/config/mailer.yml" do
    source "mailer.yml.erb"
    cookbook "mailer_config"

    # set mode, group and owner of generated file
    mode "0660"
    group deploy[:group]
    owner deploy[:user]

    # define variable “@mailer” to be used in the ERB template
    variables(:mailer => deploy[:mailer], :environment => deploy[:rails_env])

    # notifies :run, "execute[restart Rails app #{application}]"

    # only generate a file if there is mailer configuration
    only_if do
      deploy[:mailer].present? && File.directory?("#{deploy[:deploy_to]}/shared/config/")
    end
  end
end
