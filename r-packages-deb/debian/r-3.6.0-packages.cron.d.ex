#
# Regular cron jobs for the r-3.6.0-packages package
#
0 4	* * *	root	[ -x /usr/bin/r-3.6.0-packages_maintenance ] && /usr/bin/r-3.6.0-packages_maintenance
