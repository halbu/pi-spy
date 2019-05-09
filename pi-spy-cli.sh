path=~/pi-spy/pi-spy.db

# Get ROWID of the most recent reading in the db
maxrow=$(sqlite3 $path "select max(rowid) from readings;")

# Get current (i.e. most recent) readings
cur=$(sqlite3 $path "select temp, cpu_util from readings where rowid=\"$maxrow\";")
cur=(${cur//|/ })
cur_t=$(echo ${cur[0]}°C)
cur_c=$(echo ${cur[1]}%)

# Get timespan minimums and maximums
data_1d=$(sqlite3 $path "select min(temp), max(temp), min(cpu_util), max(cpu_util) from readings where timestamp >= datetime('now', 'localtime', '-1 days');")
data_1d=(${data_1d//|/ })
data_1h=$(sqlite3 $path "select max(temp), max(cpu_util) from readings where timestamp >= datetime('now', 'localtime', '-1 hours');")
data_1h=(${data_1h//|/ })
data_10m=$(sqlite3 $path "select max(temp), max(cpu_util) from readings where timestamp >= datetime('now', 'localtime', '-10 minutes');")
data_10m=(${data_10m//|/ })

min_t_1d=$(echo ${data_1d[0]}°C)
max_t_1d=$(echo ${data_1d[1]}°C)
min_c_1d=$(echo ${data_1d[2]}%)
max_c_1d=$(echo ${data_1d[3]}%)
max_t_1h=$(echo ${data_1h[0]}°C)
max_c_1h=$(echo ${data_1h[1]}%)
max_t_10m=$(echo ${data_10m[0]}°C)
max_c_10m=$(echo ${data_10m[1]}%)

echo -e "Current temp:\t\e[44m"$cur_t"\e[49m\t || 24-hour low: \e[32m"$min_t_1d"\t\e[39m || \
\tRecent maxes: \e[91m"$max_t_10m"\t\e[39m (10-minute)\t\e[91m"$max_t_1h"\t\e[39m (1-hour)\t\e[91m"$max_t_1d"\t\e[39m (24-hour)"
echo -e "Current CPU%:\t\e[44m"$cur_c"\e[49m\t || 24-hour low: \e[32m"$min_c_1d"\t\e[39m || \
\tRecent maxes: \e[91m"$max_c_10m"\t\e[39m (10-minute)\t\e[91m"$max_c_1h"\t\e[39m (1-hour)\t\e[91m"$max_c_1d"\t\e[39m (24-hour)"

