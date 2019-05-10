path=~/pi-spy/pi-spy.db
deg=$'\xc2\xb0'

# Get ROWID of the most recent reading in the db
maxrow=$(sqlite3 $path "select max(rowid) from readings;")

# Get current (i.e. most recent) readings
cur=$(sqlite3 $path "select temp, cpu_util, mem_used from readings where rowid=\"$maxrow\";")
cur=(${cur//|/ })
cur_t=$(echo ${cur[0]}°C)
cur_c=$(echo ${cur[1]}%)
cur_m=$(echo ${cur[2]}M)

# Get timespan minimums and maximums
data_1d=$(sqlite3 $path "select min(temp), max(temp), min(cpu_util), max(cpu_util), max(mem_tot), max(mem_used), max(mem_free), min(mem_used) \
from readings where timestamp >= datetime('now', 'localtime', '-1 days');")
data_1d=(${data_1d//|/ })
data_1h=$(sqlite3 $path "select max(temp), max(cpu_util), max(mem_tot), max(mem_used), max(mem_free) \
from readings where timestamp >= datetime('now', 'localtime', '-1 hours');")
data_1h=(${data_1h//|/ })
data_10m=$(sqlite3 $path "select max(temp), max(cpu_util), max(mem_tot), max(mem_used), max(mem_free) \
from readings where timestamp >= datetime('now', 'localtime', '-10 minutes');")
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
tot_m=$(echo ${data_1h[2]}M)
max_m_1d=$(echo ${data_1d[5]}M)
max_m_1h=$(echo ${data_1h[3]}M)
max_m_10m=$(echo ${data_10m[3]}M)
min_m_1d=$(echo ${data_1d[7]}M)

hi=$'\e[1;91m'
lo=$'\e[1;32m'
cu=$'\e[1;93m'
nu=$'\e[1;96m'
grey=$'\e[1;90m'
lgrey=$'\e[1;37m'
def=$'\e[0m'
br=$grey"||"$def
lbr=$grey"|"$def

printf "Current Temp: "$cu"%-8s"$def"       "$br"  24hr low: "$lo"%-8s"$def"  "$br"  Maxes: "$hi"%-7s"$def" (10m)  "$lbr"  "$hi"%-7s"$def" (1h)  "$lbr"  "$hi"%-7s"$def" (1d)\n" \
$cur_t $min_t_1d $max_t_10m $max_t_1h $max_t_1d

printf "Current CPU:  "$cu"%-7s"$def"       "$br"  24hr low: "$lo"%-7s"$def"  "$br"  Maxes: "$hi"%-6s"$def" (10m)  "$lbr"  "$hi"%-6s"$def" (1h)  "$lbr"  "$hi"%-6s"$def" (1d)\n" \
$cur_c $min_c_1d $max_c_10m $max_c_1h $max_c_1d

printf "Current Mem:  "$cu"%-4s"$def" of "$nu"%-4s"$def"  "$br"  24hr low: "$lo"%-7s"$def"  "$br"  Maxes: "$hi"%-6s"$def" (10m)  "$lbr"  "$hi"%-6s"$def" (1h)  "$lbr"  "$hi"%-6s"$def" (1d)\n" \
$cur_m $tot_m $min_m_1d $max_m_10m $max_m_1h $max_m_1d
