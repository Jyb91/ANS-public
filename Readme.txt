Le programme get_date.sh doit être dans la crontab de root toutes les minutes et génère le fichier set_date.sh dans /var/www/html/ubuntu/Packages
Le programme Test.sh est utilisé par edv_install_v3_1.bash et génère le Test.wav qui est bouclé entre casque et micro par un wrap hardware. Ce programme peut-être réutilisé.
Dans le fichier sources_list.tar il y a un jeu 32bits et un jeu 64bits à copier dans /etc/apt/sources.list pour l'accès à internet, ou au "serveur", ou à l'adresse 10.0.0.1
La commande get_conf, va afficher un QRcode avec la configuration hardware et le hostname de la machine... A finir en fonction de la requête http..
Tous les fichiers, à l'exception de get_date.sh sont dans /var/www/html/ubuntu/Packages et sont accessible par un wget http://10.0.0.1/ubuntu/Packages/progr....
Le fichier Installation loacal.odt contient la procédure d'installation sur le serveur 10.0.0.1 sans internet 
