# zeekweek-2021

See https://github.com/zeek/zeek-training ('21)

    docker pull zeekurity/zeek-training-2021
    docker run -it zeekurity/zeek-training-2021 bash

## training 1 - Fatema BW, Keith Lehigh

    zeek -Cr ../capture.pcap local
    zeek -Cr ../modbus.pcap protocols/modbus/track-memmap.zeek
    zeek -Cr ../capture.pcap local -e 'redef Site::local_nets += { 192.168.123.0/24 };'
    zeek -Cr ../modbus.pcap protocols/modbus/track-memcap.zeek

try.zeek.org

    zeek /zeek/training-res/hello-world.zeek
    zeek -Cr ../capture.pcap misc/dump-events

je kunt conn_s?.log maken en daar de 1 packet sessies in stoppen. dat zijn scans vaak.
ze noemden dat S0.

    root@7fc84e21f1bf:/zeek/training-res/hoi# zeek-cut conn_state < conn.log | sort -u
    OTH
    RSTO
    S0
    S1
    SF

kijk ook eens naar de history kolom

    root@7fc84e21f1bf:/zeek/training-res/hoi# zeek-cut history < conn.log | sort -u
    -
    D
    Dd
    S
    ShADaFdR
    ShADad
    ShADadFf
    ShADadfF
    ShADadfR
    ShAdDaFf
    ShAdDafF
    ^dA

zeek scripts:

    base        base scripts
    policy      additional scripts      inladen via local.zeek
    local       local scripts

alles begint bij `event zeek_init()` en eindigt bij `event zeek_done()`.

loop even alle policy/ stuff door.

root@7fc84e21f1bf:~# zeek-cut username password < ../map1/http.log

zkg

    zkg refresh
    zkg list all
    zkg install cve-2020-0601
    zkg list installed
    zkg info cve-2020-0601
    zkg unload cve-2020-0601
    zkg purge

files

    zkg install file-extraction
    nano /zeek/share/zeek/site/packages/file-extraction/config.zeek
    zeek -C -r /zeek/training-res/extract.pcap local.zeek
    vim /zeek/share/zeek/site/packages/file-extraction/plugins/extract-all-files.zeek
    vim /zeek/share/zeek/site/packages/file-extraction/main.zeek
    check die mimetypes en die extract functie tov onze

logging

    er staat iets over writers, ascii en dan kafka als output

versies

    major versies 1x per jaar, is 4.0.x
    daarnaast 4.1.x, dat is een feature release. komen er nooit meer dan 3 per jaar.

in een voorbeeld stond in de zeek_init iets van if c$conn_state != "S0" return, waardoor dat niet gelogged wordt.

idee: gebruik zeek scanning detectie (met die S0 etc) om potentieel scanning verkeer te flaggen. Note veld bevatte "Scan::Port_Scan", Msg bevat meer details. Deze uitleg zat bij de notice dingen.

## training 2 - Aashish Sharma

Using https://github.com/zeek/zeek-training/tree/master/ZeekWeek2021-Hands-On-Scripting

zeek-training/ZeekWeek2021-Hands-On-Scripting/00-exercise-hello-world

    > zeek 00-exercise-hello-world.zeek
    zeek_init: hello world!
    zeek_done: Wo! I feel good, I knew that I would now

hij zei dat je postgres direct kunt schrijven vanuit een script.
script is communicatie medium tussen zeek packet-processing engine en ons. zo kom je bij de zeek data structures (dmv events) en kan je daar dingen mee doen.
voorbeeld event: zeek ziet een SYN, vuurt een new_connnection event af.
events kunnen ook scheduled worden.
events kunnen ook in je script in een event aangeroepen worden.
events returnen geen value.
meerdere hooks met zelfde naam worden op priority uit gevoerd, behalve als er een `break;` statement in staat. naast hook staat optioneel `&priority = 10;`
zeek core processed ruwe data en populate events en data zeg maar.
one or more scripts create a package (maak altijd een package, met tests etc).
one or more packages make your detection platform.
default wordt altijd local.zeek ingeladen.
vanuit daar moet je de rest laden.

## talk fatema - weird.log

protocol malfunction bijv
