# Base hostname
cookbook = 'jira'

Vagrant.configure('2') do |config|
  config.berkshelf.enabled = true
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = true
  end
  config.vm.network "forwarded_port", guest: 8080, host: 4000
  config.omnibus.chef_version = :latest
  config.vm.define :ubuntu1204 do |ubuntu1204|
    ubuntu1204.vm.box      = 'opscode-ubuntu-12.04'
    ubuntu1204.vm.box_url  = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box'
    ubuntu1204.vm.hostname = "#{cookbook}-ubuntu-1204"
  end
  config.vm.provider 'virtualbox' do |v|
    v.customize ['modifyvm', :id, '--memory', 2048]
  end
  
  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug
    chef.json = {
      :java => {
        :install_flavor => :oracle,
        :oracle => {
          :accept_oracle_download_terms => true
        }
      },
      :jira => {
        :install_type => :war,
        :version => "6.2",
        :database => {
          :type => :postgresql,
          :host => :localhost,
          :name => :jira,
          :user => :jira,
          :port => 5432
        }
      },
      :postgresql => {
        :password => {
          :postgres => :postgres
        },
        :config => {
          :ssl => false
        },
        :version => 9.3
      },
      :tomcat => {
        :java_options => '-XX:MaxPermSize=256M -Xmx768M -Djava.awt.headless=true',
        :keystore_password => 'iloverandompasswordsbutthiswilldo',
        :truststore_password => 'iloverandompasswordsbutthiswilldo'
      }
    }

    chef.run_list = [
      'recipe[java]',
      'recipe[tomcat]',
      "recipe[#{cookbook}]"
    ]
  end
  config.vm.provision :shell, path: "./after_startup_scripts/after_jira_load.sh"
end
