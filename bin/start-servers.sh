echo "***************************"
echo "*** Starting Hugo Server ***"
echo "***************************"

cd hugo
hugo serve $(pwd)/../config.json &
cd ..

node_modules/.bin/nodemon         \
    -w ./node/jira-proxy/src/     \
    -w ./node/jira-issues/src/    \
    -w ./node/jira-mappings/src/  \
    bin/start-jira-proxy.coffee $(pwd)/config.json
