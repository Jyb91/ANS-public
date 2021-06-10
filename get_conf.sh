#!/usr/bin/bash
uname -nrv |awk '{printf("%s %s %s\n",$1,$2,$3)}' > Conf.txt
lshw -short |grep  -e 'System Memory' |awk '{printf("%s %s\n",$2,$3)}' >> Conf.txt
lshw -short |grep  -e 'processor' |awk '{i=2;while (i<=NF) {printf("%s ",$i);i++}} END {printf("\n")}' >> Conf.txt
lshw -short |grep  -e 'network' |awk '{i=2;while (i<=NF){printf("%s ",$i);i++};printf("\n")}' >>Conf.txt
qrencode -s 7 -o Conf.png -r Conf.txt
lximage-qt Conf.png

