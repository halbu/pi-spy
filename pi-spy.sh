while sleep 30; do
temp=$(vcgencmd measure_temp | cut -d "=" -f2 | cut -d "'" -f1)
mem=($(free -h | sed -n 2p | tr -d 'M' | tr -s ' ' '\n'))
mem_tot=${mem[1]}
mem_used=${mem[2]}
mem_free=${mem[3]}
mem_bc=${mem[5]}
cpu_idle=$(top -b -n2 -d1 | grep '%Cpu' | sed -n 2p | sed 's/ id,.*//g' | sed 's/.*ni, //')
cpu_util=$(echo 1 k 100 $cpu_idle - p | dc)
sdc=($(df | grep /dev/root | tr -s ' ' \\n))
sdc_used=$((${sdc[2]}*100))
sdc_pct=$(echo 1 k $sdc_used ${sdc[1]} / p | dc)
tdate=$(date +%F' '%T)
sqlite3 pi-spy.db "insert into readings values(\"$temp\", \"$mem_tot\",\
 \"$mem_used\", \"$mem_free\", \"$mem_bc\", \"$cpu_util\", \"$sdc_pct\", \"$tdate\")";
done;
