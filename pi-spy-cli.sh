path=~/pi-spy/pi-spy.db
path=~/pi-spy/pi-spy.db

# Get ROWID of the most recent reading in the db
maxrow=$(sqlite3 $path "select max(rowid) from readings;")

# Get current (i.e. most recent) readings
cur=$(sqlite3 $path "select temp, cpu_util from readings where rowid=\"$maxrow\";")
cur=(${cur//|/ })
cur_t=$(echo ${cur[0]}°C)
cur_c=$(echo ${cur[1]}%)

# Get timespan minimums and maximums
data_1d=$(sqlite3 $path "select min(temp), max(temp), min(cpu_util), max(cpu_util), max(mem_tot), max(mem_used), max(mem_free), min(mem_used) from readings where timestamp >= datetime('now', 'localtime', '-1 days');")
data_1d=(${data_1d//|/ })
data_1h=$(sqlite3 $path "select max(temp), max(cpu_util), max(mem_tot), max(mem_used), max(mem_free) from readings where timestamp >= datetime('now', 'localtime', '-1 hours');")
data_1h=(${data_1h//|/ })
data_10m=$(sqlite3 $path "select max(temp), max(cpu_util), max(mem_tot), max(mem_used), max(mem_free) from readings where timestamp >= datetime('now', 'localtime', '-10 minutes');")
data_10m=(${data_10m//|/ })

# Minimum and maximum CPU and temp values for each timeframe
min_t_1d=$(echo ${data_1d[0]}°C)
max_t_1d=$(echo ${data_1d[1]}°C)
min_c_1d=$(echo ${data_1d[2]}%)
max_c_1d=$(echo ${data_1d[3]}%)
max_t_1h=$(echo ${data_1h[0]}°C)
max_c_1h=$(echo ${data_1h[1]}%)
max_t_10m=$(echo ${data_10m[0]}°C)
max_c_10m=$(echo ${data_10m[1]}%)

# Total memory
mem_tot=$(echo ${data_1h[2]}M)
mem_used_1d=$(echo ${data_1d[5]}M)
mem_free_1d=$(echo ${data_1d[6]}M)
mem_used_1h=$(echo ${data_1h[3]}M)
mem_free_1h=$(echo ${data_1h[4]}M)
mem_used_10m=$(echo ${data_10m[3]}M)
mem_free_10m=$(echo ${data_10m[4]}M)
min_mem_1d=$(echo ${data_1d[7]}M)

echo -e "Temp   \e[44m"$cur_t"\t\e[49m\t | 24-hour low: \e[32m"$min_t_1d"\t\e[39m | \
Recent maxes: \e[91m"$max_t_10m"\t\e[39m (10-minute)\t\e[91m"$max_t_1h"\t\e[39m (1-hour)\t\e[91m"$max_t_1d"\t\e[39m (24-hour)"
echo -e "CPU%   \e[44m"$cur_c"\t\e[49m\t | 24-hour low: \e[32m"$min_c_1d"\t\e[39m | \
Recent maxes: \e[91m"$max_c_10m"\t\e[39m (10-minute)\t\e[91m"$max_c_1h"\t\e[39m (1-hour)\t\e[91m"$max_c_1d"\t\e[39m (24-hour)"
echo -e "Memory \e[44m"$mem_used_1h"\e[49m / \e[44m"$mem_tot"\t\e[49m | 24-hour low: \e[32m"$min_mem_1d"\t\e[39m | \
Recent maxes: \e[91m"$mem_used_10m"\t\e[39m (10-minute)\t\e[91m"$mem_used_1h"\t\e[39m (1-hour)\t\e[91m"$mem_used_1d"\t\e[39m (24-hour)"
