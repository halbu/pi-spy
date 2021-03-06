extended_output=0
custom_timespan=0
t_arr=''
t_int=0
t_unit=''

# Parse flags, if any
while getopts 'xt:' flag; do
  case "${flag}" in
    x) extended_output=1 ;;
    t) custom_timespan=1; t_arr=$(grep -Eo '[[:alpha:]]+|[0-9]+' <<< "$OPTARG" | tr ' ' '\n'); echo ${t_arr[0]}; echo ${t_arr[1]} ;;
  esac
done

if [ $custom_timespan -eq "1" ] ; then
  echo 'Custom timespan value: ' ${t_arr[0]}
  echo 'Custom timespan units: ' ${t_arr[1]}
fi

# Path, colors, substrings
path=~/pi-spy/pi-spy.db
hi=$'\e[1;91m'
lo=$'\e[1;32m'
cu=$'\e[1;93m'
nu=$'\e[1;96m'
grey=$'\e[1;90m'
lgrey=$'\e[1;37m'
def=$'\e[0m'
br=$grey"||"$def
lbr=$grey"|"$def

# Get current (i.e. most recent) readings
maxrow=$(sqlite3 $path "select max(rowid) from readings;")
cur=$(sqlite3 $path "select temp, cpu_util, mem_used, sdc_mem from readings where rowid=\"$maxrow\";")
cur=(${cur//|/ })
cur_t=$(echo ${cur[0]}°C)
cur_c=$(echo ${cur[1]}%)
cur_m=$(echo ${cur[2]}M)
cur_sd=$(echo ${cur[3]}%)

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
max_m_1d=$(echo ${data_1d[5]}M)
max_m_1h=$(echo ${data_1h[3]}M)
max_m_10m=$(echo ${data_10m[3]}M)
min_m_1d=$(echo ${data_1d[7]}M)
tot_m=$(echo ${data_1h[2]}M)

printf "\n"$grey"%-10s"$def" "$br"  %-13s "$br"  %-10s "$br"  %-10s "$lbr"  %-10s "$lbr"  %-12s\n" \
"pi-spy" "Most Recent" "Min (24h)" "Max (10m)" "Max (1hr)" "Max (24h)"

printf $grey"───────────┤├────────────────┤├─────────────┤├─────────────┼─────────────┼────────────\n"$def

printf "%-10s "$br"  "$cu"%-14s"$def" "$br"  "$lo"%-11s"$def" "$br"  "$hi"%-11s"$def" "$lbr"  "$hi"%-11s"$def" "$lbr"  "$hi"%-15s"$def"\n" \
"Core Temp" $cur_t $min_t_1d $max_t_10m $max_t_1h $max_t_1d

printf "%-10s "$br"  "$cu"%-13s"$def" "$br"  "$lo"%-10s"$def" "$br"  "$hi"%-10s"$def" "$lbr"  "$hi"%-10s"$def" "$lbr"  "$hi"%-14s"$def"\n" \
"CPU Load" $cur_c $min_c_1d $max_c_10m $max_c_1h $max_c_1d

printf "%-10s "$br"  "$cu"%-4s"$def" of "$nu"%-5s"$def" "$br"  "$lo"%-10s"$def" "$br"  "$hi"%-10s"$def" "$lbr"  "$hi"%-10s"$def" "$lbr"  "$hi"%-14s"$def"\n" \
"RAM Usage" $cur_m $tot_m $min_m_1d $max_m_10m $max_m_1h $max_m_1d

if [ $extended_output -eq "1" ] ; then
  printf $grey"───────────┴┴────────────────┴┴─────────────┴┴─────────────┴─────────────┴────────────\n"$def
  printf "SD Card memory usage: %s\n" $cur_sd
fi

printf "\n"

