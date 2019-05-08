while sleep 30; do
temp=$(vcgencmd measure_temp | cut -d "=" -f2 | cut -d "'" -f1)
mem=($(free -h | sed -n 2p | tr -d 'M' | tr -s ' ' '\n'))
mem_tot=${mem[1]}
mem_used=${mem[2]}
mem_free=${mem[3]}
mem_bc=${mem[5]}
cpu=($(vmstat | sed -n 3p | tr -s ' ' '\n'))
cpu_util=$((100-${cpu[14]}))
tdate=$(date +%F' '%T)
sqlite3 pi-spy.db "insert into readings values(\"$temp\", \"$mem_tot\",\
 \"$mem_used\", \"$mem_free\", \"$mem_bc\", \"$cpu_util\", \"$tdate\")";
done;
