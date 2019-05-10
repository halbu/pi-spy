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

sudo systemctl stop pi-spy
sudo rm /etc/systemd/system/pi-spy.service
sudo cp ./pi-spy.service /etc/systemd/system/pi-spy.service
sudo systemctl daemon-reload
sudo systemctl start pi-spy
sudo systemctl enable pi-spy
echo "Pi-Spy monitoring service installed, enabled and running."

if [ -f /usr/bin/pi-spy-cli ] ; then
    sudo rm /usr/bin/pi-spy-cli;
fi
cp pi-spy-cli.sh pi-spy-cli2.sh
sudo chmod 700 pi-spy-cli2.sh
sudo mv pi-spy-cli2.sh /usr/bin/pi-spy-cli
echo "Pi-Spy CLI (such as it currently is) copied to /usr/bin. Use the 'pi-spy-cli' command to see output."
