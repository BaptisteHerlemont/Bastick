BaStick est un programme permettant de trouver des candidats pour de potentielles protéines adhésives dans un transcriptome à partir d'une banque de protéines adhésives.

Comment télécharger Bastick 

Télécharger le programme : 
wget https://github.com/BaptisteHerlemont/Bastick/blob/main/bastick.bash

Télécharger le Makefile :
wget https://github.com/BaptisteHerlemont/Bastick/blob/main/makefile

Rendre le script utilisable :
sudo make use 

Vérifier que la commande précedente fonctionne : 
./bastick.sh -H 
=> le menu d'aide doit s'afficher
