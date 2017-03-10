node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  # Chef::Log.info("Symlinking #{deploy[:current_path]}/public/assets to #{new_resource.deploy_to}/shared/assets")

  # link ::File.join(deploy[:current_path], 'public', 'assets') do
  #   to ::File.join(deploy[:deploy_to], 'shared', 'assets')
  # end

  # rails_env = new_resource.environment["RAILS_ENV"]
  # Chef::Log.info("Precompiling assets for RAILS_ENV=#{rails_env}...")
  Chef::Log.info("Precompiling rails assets...")

  execute 'npm install' do
    cwd ::File.join(deploy[:current_path], 'webpack')
    # user deploy[:user]
    command 'npm install'
    environment deploy[:environment]
  end

  execute 'rake assets:precompile' do
    cwd deploy[:current_path]
    # user deploy[:user]
    command 'bundle exec rake assets:precompile'
    environment deploy[:environment]
  end

  execute "unicorn restart" do
    cwd deploy[:current_path]
    command ::File.join(deploy[:deploy_to], 'shared', 'scripts', 'unicorn restart')
    environment deploy[:environment]
  end
end
