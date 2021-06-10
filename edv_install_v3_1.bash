#!/bin/bash
# Version 2 mise à l'heure automatique
# Version 3 install qreator pour QR code
#IP du serveur
echo "Entrez l'adresse IP du serveur"
read serveur
echo "Adresse IP du serveur: "$serveur

# test si on est root ou sudo
test=`whoami`
if [ $test != "root" ]; then
  echo "A lancer avec sudo"
  exit
fi

# Mise à l'heure
wget  http://$serveur/ubuntu/Packages/set_date.sh
chmod +x set_date.sh
./set_date.sh

# Récupération du fichier sources.list et test réseau.
#vérifie la distrib
distrib="$(lsb_release -a | grep Description)"
if [[ $distrib == *"Ubuntu 20"* ]]; then
        soixantequatrebits="true"
	wget  http://$serveur/ubuntu/Packages/sources.list_64bits
	if [ $? != 0 ]; then
        echo "Récuperation des sources.list impossible, vérifiez l'accés au serveur"
        exit
		fi
		cat sources.list_64bits | sed "s/serveur/$serveur/g" > /etc/apt/sources.list
else
        soixantequatrebits="false"
	wget http://$serveur/ubuntu/Packages/sources.list_32bits
	        if [ $? != 0 ]; then
        echo "Récuperation des sources.list impossible, vérifiez l'accés au serveur"
        exit
		fi
		cat sources.list_32bits | sed "s/serveur/$serveur/g" > /etc/apt/sources.list
fi

# Mises à jour
apt update
apt -y upgrade

if [[ $soixantequatrebits == "true" ]]; then

        # install skype + discord
        type discord
        if [ $? != 0 ]; then
	wget http://$serveur/ubuntu/Packages/discord-0.0.14.deb 
	if [ $? != 0 ]; then
        	echo "Récuperation de discord impossible, vérifiez l'accés au serveur"
        	exit
		fi
	apt-get -y --fix-missing install  ./discord-0.0.14.deb
        fi

	type skype
        if [ $? != 0 ]; then
	wget http://$serveur/ubuntu/Packages/skypeforlinux-64.deb
	if [ $? != 0 ]; then
        	echo "Récuperation de skype impossible, vérifiez l'accés au serveur"
        	exit
		fi
	apt-get -y --fix-missing install ./skypeforlinux-64.deb
	fi
else
        #install libreoffice
        libreoffice --help
        if [ $? != 0 ]; then
                apt-get -y install libreoffice-writer libreoffice-calc libreoffice-impress
        fi

        #install vlc
        vlc --help
        if [ $? != 0 ]; then
                apt-get -y install vlc
        fi

fi

apt-get -y install audacity


# Passe libreoffice en français
apt-get -y install libreoffice-l10n-fr



# TODO : plugins libre-office
# ajoute le plugin libreoffice cartable fantastique
# su - user
# unopkg add -s --shared ./Lbo_CartableFantastique.v2.oxt
# exit
# ajouter également le plugin grammalecte
# + plugin dmaths

# Passe Firefox en Français
locale-gen fr_FR fr_FR.UTF-8
apt-get -y --fix-missing install firefox-locale-fr
LC_ALL=fr_FR firefox -no-remote

#télécharge la vidéo sur le bureau
curl --help
if [ $ != 0 ]; then
        apt-get -y install curl
fi


#Installation WIFI
  wget  http://192.168.1.65/ubuntu/Packages/WIFI/rtl8188fu.tar
  tar -xvf rtl8188fu.tar
  apt -y install dkms
  dkms add ./rtl8188fu
  dkms build rtl8188fu/1.0
  dkms install rtl8188fu/1.0
  cp ./rtl8188fu/firmware/rtl8188fufw.bin /lib/firmware/rtlwifi/

#Installation des outils
apt-get -y install pv hdparm smartmontools gsmartcontrol psensor memtester net-tools hardinfo
#Installation Qreactor
apt-get -y qreator

# Télécharge la documentation sur le bureau
fileName=Lubuntu-introduction.avi
docName=EDV-Documentation-Lubuntu.odp
test -d Desktop
if [[ $? == 0 ]] ; then
	wget http://$serveur/ubuntu/Packages/${fileName}
	mv Lubuntu-introduction.avi /home/user/Desktop/.
	wget http://$serveur/ubuntu/Packages/${docName}
	mv EDV-Documentation-Lubuntu.odp /home/user/Desktop/.
else
	wget http://$serveur/ubuntu/Packages/${fileName}
	mv Lubuntu-introduction.avi /home/user/Bureau/.
	wget http://$serveur/ubuntu/Packages/${docName}
	mv EDV-Documentation-Lubuntu.odp /home/user/Bureau/.
fi


#Restauration sources.list
if [[ $soixantequatrebits == "true" ]]; then
        wget http://$serveur/ubuntu/Packages/sources.list_64bits_ORI
        mv sources.list_64bits_ORI /etc/apt/sources.list
else
        wget http://$serveur/ubuntu/Packages/sources.list_32bits_ORI
        mv sources.list_32bits_ORI /etc/apt/sources.list
fi
#Chargement du test sde son
	wget http://$serveur/ubuntu/Packages/Test.wav
	wget http://$serveur/ubuntu/Packages/Test.sh



# vérifications
curl --help
resultCurl=$?
test -d Desktop
if [[ $? == 0 ]] ; then
test -e Desktop/$fileName
resultVideo=$?
test -e Desktop/$docName
resultDoc=$?
else
	test -e Bureau/$fileName
	resultVideo=$?
	test -e Bureau/$docName
	resultDoc=$?
fi
skypeforlinux --help
resultSkype=$?
type discord 
resultDiscord=$?
su - user - 'vlc --help'
resultVLC=$?
libreoffice --help
resultlibreoffice=$?

clear
echo "_______________________________ Résultats du script _______________________________"
if [ $resultCurl == 0 ]; then
        echo "Installation de CURL------------------------------------------------------------ OK"
else
        echo "Installation de CURL------------------------------------------------------------ ERREUR"
fi
if [ $resultVideo == 0 ]; then
        echo "Téléchargement de la vidéo ----------------------------------------------------- OK"
else
        echo "Téléchargement de la vidéo ----------------------------------------------------- ERREUR"
fi
if [ $resultDoc == 0 ]; then
        echo "Téléchargement de la documentation --------------------------------------------- OK"
else
        echo "Téléchargement de la documentation --------------------------------------------- ERREUR"
fi

if [[ $soixantequatrebits == "true" ]]; then
        if [ $resultSkype == 0 ]; then
                echo "Installation de skype ---------------------------------------------------------- OK"
        else
                echo "Installation de skype ---------------------------------------------------------- ERREUR"
        fi
        if [ $resultDiscord == 0 ]; then
                echo "Installation de Discord -------------------------------------------------------- OK"
        else
                echo "Installation de Discord -------------------------------------------------------- ERREUR"
        fi
else
        if [ $resultVLC == 0 ]; then
                echo "Installation de VLC ------------------------------------------------------------- OK"
        else
                echo "Installation de VLC ------------------------------------------------------------- ERREUR"
        fi
        if [ $resultlibreoffice == 0 ]; then
                echo "Installation de LibreOffice-------------------------------------------------- OK"
        else
                echo "Installation de LibreOffice ------------------------------------------------- ERREUR"
        fi
fi
echo "Branchez le wrap (\ avec les enceintes si il n'y a pas de HP interne \)  et vous devriez entrendre 2 sons "
arecord -d 10 -f cd -t wav /tmp/test.wav &
aplay Test.wav
wait
aplay /tmp/test.wav




echo "_______________________"
echo "< Installation terminée >"
echo " -----------------------"
echo "          \ "
echo "           \ "
echo "            \          __---__"
echo "                    _-       /--______"
echo "               __--( /     \ )XXXXXXXXXXX\v."
echo "             .-XXX(   O   O  )XXXXXXXXXXXXXXX-"
echo "            /XXX(       U     )        XXXXXXX\ "
echo "          /XXXXX(              )--_  XXXXXXXXXXX\ "
echo "         /XXXXX/ (      O     )   XXXXXX   \XXXXX\ "
echo "         XXXXX/   /            XXXXXX   \__ \XXXXX"
echo "         XXXXXX__/          XXXXXX         \__----> "
echo " ---___  XXX__/          XXXXXX      \__         / "
echo "   \-  --__/   ___/\  XXXXXX            /  ___--/= "
echo "    \-\    ___/    XXXXXX              '--- XXXXXX"
echo "       \-\/XXX\ XXXXXX                      /XXXXX"
echo "         \XXXXXXXXX   \                    /XXXXX/"
echo "          \XXXXXX      >                 _/XXXXX/ "
echo "            \XXXXX--__/              __-- XXXX/ "
echo "             -XXXXXXXX---------------  XXXXXX-"
echo "                \XXXXXXXXXXXXXXXXXXXXXXXXXX/ "
echo "                  ""VXXXXXXXXXXXXXXXXXXV"" "


exit 0 
