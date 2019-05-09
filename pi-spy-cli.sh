path=~/pi-spy/pi-spy.db
mm=$(sqlite3 $path "select min(temp), max(temp) from readings where timestamp >= datetime('now', 'localtime', '-1 days');")
maxrow=$(sqlite3 $path "select max(rowid) from readings;")
cur_t=$(sqlite3 $path "select temp from readings where rowid=\"$maxrow\";")
min_t_1d=($(echo $mm | cut -f1 -d '|'))
max_t_1d=($(echo $mm | cut -f2 -d '|'))
max_t_1h=$(sqlite3 $path "select max(temp) from readings where timestamp >= datetime('now', 'localtime', '-1 hours');")
max_t_10m=$(sqlite3 $path "select max(temp) from readings where timestamp >= datetime('now', 'localtime', '-10 minutes');")
echo -e "Current temp: \e[44m"$cur_t"°C\e[49m || 24-hour low: \e[32m"$min_t_1d"°C\e[39m || \
Recent maxes: \e[91m"$max_t_10m"°C\e[39m (10-minute) - \e[91m"$max_t_1h"°C\e[39m (1-hour) - \e[91m"$max_t_1d"°C\e[39m (24-hour)"

