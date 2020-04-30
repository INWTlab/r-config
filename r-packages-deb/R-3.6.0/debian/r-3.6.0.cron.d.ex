#
# Regular cron jobs for the r-3.6.0 package
#
0 4	* * *	root	[ -x /usr/bin/r-3.6.0_maintenance ] && /usr/bin/r-3.6.0_maintenance
