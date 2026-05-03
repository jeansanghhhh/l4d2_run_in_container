docker run -itd --name l4d2 \
-p 27015:27015
-v /lib/games/steam/left4dead2:/home/steam/left4dead2 \
cm2network/steamcmd:latest \
/home/steam/left4dead2/srcds_run -game left4dead2 -debug -insecure \
+sv_lan 1 +sv_gametypes "coop" +hostname "left4dead2" +exec server.cfg +map c2m1_highway