settings = Jira.settings(node)

directory node['jira']['lib_path'] do
  action :create
end

mysql_connector_j node['jira']['lib_path'] if settings['database']['type'] == 'mysql'

if settings['database']['type'] == 'postgresql'
  postgres_filename = node['jira']['lib_path'] + "/postgres.jar"
  puts "Downloading postgres to #{postgres_filename}"
  remote_file postgres_filename do
  	source "http://repo1.maven.org/maven2/postgresql/postgresql/9.1-901.jdbc4/postgresql-9.1-901.jdbc4.jar"
  	mode 00644
  	:create_if_missing
  end
end

jira_jars node['jira']['jars']['install_path'] do
  action :deploy
  only_if { node['jira']['install_type'] == 'war' && node['jira']['container_server']['name'] == 'tomcat' }
end
