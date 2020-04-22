#
# Regular cron jobs for the inwt package
#
0 4	* * *	root	[ -x /usr/bin/inwt_maintenance ] && /usr/bin/inwt_maintenance
