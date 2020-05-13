# Regime Switching and Technical Trading with Dynamic Bayesian Networks in High-Frequency Stock Markets

# Description
* Dossier "Articles" contient tous les articles que nous avons utilisés comme support pour travailler sur ce projet. Il contient 3 articles : deux articles traitant du "Regime Switching and Technical Trading with Dynamic Bayesian Networks in High-Frequency Stock Markets" dont celui écrit par Aditya Tayal en 2009 qui est le papier source, le papier écrit par Luis Daminiano, Brian Peterson et Michael Weylandt est une mise-à-jour du modèle de Tayal ainsi que son implémentation. Le dernier article "A Tutorial on Hidden Markov Model using Stan" écrit par les 3 auteurs précédents décrit la manière d'implémenter un HMM en utilisant le logiciel Stan.
* Dossier "Data" contient les données utilisées dans le cadre de ce projet, ce sont les données intraday de l'actif financier de la compagnie Goldcorp Inc. sur 5 jours ouvrés : du 01/05/2007 au 07/05/2007.
* Fichier "Config.stan" correspond au script de configuration pour exécuter l'inférence statistique en utilisant le logiciel Stan sous R.
* Fichier "Feature Extraction.R" correspond au script R afin de créer les features du modèle.
* Fichier "Main.R" correspond au script R principal faisant appel aux deux précédents.
* Fichier pdf correspond à notre résumé du projet.

# Instructions pour lancer le code :
* Cloner le git et ouvrir le script "Main.R"
* Avant de lancer le script, il est nécessaire d'installer Stan sous R (cela passe par l'installation d'un compilateur C++ et de Rtools) en utilisant le lien suivant : https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started?fbclid=IwAR3DvfIWhOUyU7hWUdulzcLNQRcMCwLm_o91tAzW1RlkNac78RrDYIrwRms et notamment de la commande suivante : pkgbuild::has_build_tools(debug = TRUE)
* Lancer le script "Main.R", cela peut prendre un certain temps d'exécution selon la puissance de la machine. 
* Les OUTPUTS sont : le vecteur de probabilités initiales, la matrice de transition et les probabilités conditionnelles.

# Auteurs
* Eléonore Blanchard
* Yannick Ly
