BaStick est un programme permettant de trouver des candidats pour de potentielles protéines adhésives dans un transcriptome à partir d'une banque de protéines adhésives.

-Comment télécharger Bastick 

Télécharger Git :
sudo apt-get install git

Téléchargez le programme et le Makefile: 
git clone https://github.com/BaptisteHerlemont/Bastick

Allez dans le répertoire créé : 

cd Bastick/

Rendre le script utilisable :
sudo make use 

Vérifiez que la commande d'aide fonctionne : 

./bastick.sh -H 

=> le menu d'aide suivant doit s'afficher


![menudaide](https://user-images.githubusercontent.com/94676429/166201531-2297bd90-ce87-4030-a8b2-df33fe176aef.png)


-Comment utiliser Bastick

Vous devez posséder : 

-Hmmer, téléchargeable ici : http://hmmer.org/download.html

-Blast, téléchargeable ici : https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download

-Seqtk, téléchargeable ici : https://github.com/lh3/seqtk

BaStickUniq est un programme permettant de réaliser les mêmes analyses mais sur une seule protéine d'une banque.
