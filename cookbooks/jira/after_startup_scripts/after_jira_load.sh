echo "Now we are going to run an automatic configuration of JIRA using this Selenium Script https://github.com/ctapobep/jira-selenium"

jira_license=`cat /vagrant/after_startup_scripts/jira_license`

echo "Downloading Selenium script to initially setup JIRA with admin/admin user"
wget https://dl.dropboxusercontent.com/u/2397949/scripts/jira-selenium.jar
echo "Running the Selenium scenario"
java -jar jira-selenium.jar \
  http://localhost:8080/jira \
  $jira_license
echo "Hopefully JIRA was configured successfully, log in with admin/admin"