<?php
/**
 * The base configurations of the WordPress.
 *
 * This file has the following configurations: MySQL settings, Table Prefix,
 * Secret Keys, WordPress Language, and ABSPATH. You can find more information
 * by visiting {@link http://codex.wordpress.org/Editing_wp-config.php Editing
 * wp-config.php} Codex page. You can get the MySQL settings from your web host.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to "wp-config.php" and fill in the values.
 *
 * @package WordPress
 */

// ** MySQL settings ** //
$db_data = array(
	'database' => 'wordpress_development',
	'username' => 'plminus',
	'password' => '49e8d5602b1557be',
	'host'     => 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
//	'database' => 'wordpress',
//	'username' => 'plminus',
//	'password' => '0291d7f08ea70bf4',
//	'host'     => 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
);

define('DB_NAME',     $db_data['database']);
define('DB_USER',     $db_data['username']);
define('DB_PASSWORD', $db_data['password']);
define('DB_HOST',     $db_data['host']);
define('DB_CHARSET',  'utf8');
define('DB_COLLATE',  '');
//define('DB_COLLATE',  'utf8_general_ci');

unset($db_data);

/** Enable Redis Object Cache **/
// http://se-suganuma.blogspot.jp/2015/01/wordpresscacheapcredis.html
// https://wordpress.org/plugins/redis-cache/other_notes/
define('WP_REDIS_SCHEME',   'tcp');
define('WP_REDIS_HOST',     'localhost');
define('WP_REDIS_PORT',     '6379');
define('WP_REDIS_DATABASE', '0');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'f:R8/%3qw6dC[)6;-i,tY[By+AO^8(rLPv*L[i3<Q?8]BYrXm^]N<T6VLe)+p-:b');
define('SECURE_AUTH_KEY',  '[:w_:eUp#nu|hh{#RuKaSI(G`/Kt!a`qXbR, S$@{`{|lnWW-,+y#)*GEnhBEAUg');
define('LOGGED_IN_KEY',    'K=cdt9`$Y>$q#%.rKR5j(]Ly6=/q?=/gR$8xhJ;fI-f2^+NNJQr<#nB!ty?{W0)~');
define('NONCE_KEY',        'yO)cO0q_/~wmWe~V[>BkHUT|3TGsT,|v&3,FiQGZ$sd./4sZh;Yx|/pW8e i@z]D');
define('AUTH_SALT',        '>%fRaz7h7R}UB^C%,]t{|tX)DY/O[{z+df)}_DRJ6dIRNj2e> V~,25R+S0J-a{N');
define('SECURE_AUTH_SALT', '%vSs`I3Gl+e$jAPkQN*e72t)KP|Fo(^Y-=RqY.(.S9~Xwhn_X^ht-Kf*+CCd$IwI');
define('LOGGED_IN_SALT',   'Lvk.{8}21D8CMOQV]@jFcOT=7Uj&dSx68=l{1&ycjD#9b%2}tQDX1]@Sm%$tXJOU');
define('NONCE_SALT',       ']5Y%^J^e>ro:70M1NX#jye8+|nk^B9$C WAHOM:V~-z7mBnfP4E]**ii jf{DLFf');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * WordPress Localized Language, defaults to English.
 *
 * Change this to localize WordPress. A corresponding MO file for the chosen
 * language must be installed to wp-content/languages. For example, install
 * de_DE.mo to wp-content/languages and set WPLANG to 'de_DE' to enable German
 * language support.
 */
define('WPLANG', 'ja');

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 */
define('WP_DEBUG',         true );
define('WP_DEBUG_LOG',     true );
define('WP_DEBUG_DISPLAY', false);
define('SAVEQUERIES',      false);

/** set FS_METHOD */
define('FS_METHOD', 'direct');

/** set autosave interval */
define('AUTOSAVE_INTERVAL', 3600 );

/** disable post revisions */
define('WP_POST_REVISIONS', false);

/** disable wp-cron */
define('DISABLE_WP_CRON',   true );

/** disable Wordpress AUTOMATIC UPDATE */
define('AUTOMATIC_UPDATER_DISABLED', true);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
