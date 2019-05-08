if [ -f pi-spy.db ] ; then
    rm pi-spy.db; echo "Old Pi-Spy database deleted.";
fi

sqlite3 pi-spy.db "create table readings(\
 temp DOUBLE NOT NULL,\
 mem_tot INT NOT NULL,\
 mem_used INT NOT NULL,\
 mem_free INT NOT NULL,\
 mem_bc INT NOT NULL,\
 cpu_util INT NOT NULL,\
 timestamp DATETIME NOT NULL);"
echo "New Pi-Spy database created."

sleep 0.5s

sudo rm /etc/systemd/system/pi-spy.service
sudo cp ./pi-spy.service /etc/systemd/system/pi-spy.service
sudo systemctl daemon-reload
sudo systemctl start pi-spy
sudo systemctl enable pi-spy
echo "Pi-Spy service configured and enabled."
