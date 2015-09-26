#!/bin/bash
#set -e
#set -u
#set -x

CWD=`pwd`
SWD=`(cd \`dirname $0\` && pwd)`

export FUNCTIONS=$SWD/.functions
export PLATFORM=aws

# trap
trap 'echo -e "\nabort\n" ; exit 1' 1 2 3 15

# run scripts {{{

#$SWD/packages/awscli/build.sh
$SWD/packages/fail2ban/build.sh
$SWD/packages/nginx/build.sh
$SWD/packages/goaccess/build.sh
$SWD/packages/redis/build.sh
$SWD/packages/percona56/build_client.sh
$SWD/packages/percona56/build_server.sh
$SWD/packages/php56/build_cli.sh
$SWD/packages/php56/build.sh
$SWD/packages/php56/build_fpm.sh
$SWD/packages/wp-cli/build.sh
#$SWD/packages/newrelic/build.sh
#$SWD/packages/newrelic-php5/build.sh
#$SWD/packages/newrelic-plugin-agent/build.sh
$SWD/roles/aws-wordpress-develop/build.sh

# }}}

unset FUNCTIONS
unset PLATFORM

exit 0
