#!/bin/bash
#set -e
#set -u
#set -x

CWD=`pwd`
SWD=`(cd \`dirname $0\` && pwd)`

# load functions
test ! "$FUNCTIONS" && FUNCTIONS="$SWD/../../.functions"
. $FUNCTIONS/*.sh

# trap
trap 'echo -e "\nabort\n" ; exit 1' 1 2 3 15

# http://wp-cli.org/
WP_CLI_PATH=/usr/local/bin
WP_CLI_BIN=wp
WP_CLI_URL="https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"

WP_CLI_COMPLETION_PATH=/etc/profile.d
WP_CLI_COMPLETION_BIN=wp-cli.sh
WP_CLI_COMPLETION_URL="https://raw.githubusercontent.com/wp-cli/wp-cli/master/utils/wp-completion.bash"

# download wp-cli.phar {{{

sudo bash -c "curl -Lk  $WP_CLI_URL > $WP_CLI_PATH/$WP_CLI_BIN"
sudo chmod 755 $WP_CLI_PATH/$WP_CLI_BIN

$WP_CLI_PATH/$WP_CLI_BIN --info

# }}}
# download bash-completion {{{

sudo bash -c "curl -Lk  $WP_CLI_COMPLETION_URL > $WP_CLI_COMPLETION_PATH/$WP_CLI_COMPLETION_BIN"
sudo chmod 644 $WP_CLI_COMPLETION_PATH/$WP_CLI_COMPLETION_BIN

# }}}

exit 0
