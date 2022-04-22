#!/bin/bash
#~ valeur par defaut du nombre de cpu 
nmbcpu="2"
#~ valuer par defaut de la evalue
evalue="1e-10"
#~ valeur par defaut du tx dexpression des valeurs FPKM
txfpkm="2"
while getopts ":p:t:f:b:s:d:Hl:u:F:n:e:" option
do
echo "getops a trouvé l'option $option"
case $option in 
p)
	banqueprot="$OPTARG"
	;;
t)
	transcriptome="$OPTARG"
	;;
f)
	fichierFPKM="$OPTARG"
	;;
b)
	cheminblast="$OPTARG"
	$cheminblast/tblastn 2>/dev/null
	verblast=$(echo $?)
	if
	(( "verblast" == "1" ))
	then
	echo "Blast est bien installé et vous avez bien renseigné le chemin de blast "
	blastok=1
	else
	echo "Votre chemin vers blast est faux ou le programme blast n'est pas installé"
	blastok=2
	fi
	;;
s)
	cheminseqtk="$OPTARG"
	$cheminseqtk/seqtk 2>/dev/null
	verseqtk=$(echo $?)
	if
	(( "verseqtk" == "1" ))
	then
	echo "seqtk est bien installé et vous avez bien renseigné le chemin de seqtk "
	seqtkok=1
	else
	echo "Votre chemin vers seqtk est faux ou le programme seqtk n'est pas installé"
	seqtk=2
	fi
	;;
d)
	domaine="$OPTARG"
	;;
H)
	echo "ARGUMENTS OBLIGATOIRES
-p			STRING			pour indiquer la banque de protéines
-t			STRING			pour indiquer le transcriptome
-f			STRING			pour indiquer le fichier avec les valeurs FPKM au format CSV 
-b			STRING			pour indiquer le chemin de BLAST
-s			STRING			pour indiquer le chemin de seqkt
-h			STRING			pour indiquer le chemin de hmmear
-d			STRING			pour indiquer la banque de domaine 
ARGUMENTS OPTIONNELS
-n			INT			pour indiquer le nombre de CPU à utiliser (2par défauts)
-e			INT			pour indiquer la valeur seuil d'e value (1e-10 par defaut)
-F			STRING			pour indiquer si vous voulez utiliser les valeurs de FPKM (Y or N )
-T			INT			pour indiquer  le taux d'expression des valeurs FPKM à utiliser ( 2 par défaut )
-H						affiche ce menu d'aide
-l     					affiche la liste des protéines et offre la possibilité de lancer le programme sur 1 de la liste "
	;;
n)
	nmbcpu="$OPTARG"
	if [[ $OPTARG = +([0-9]) ]]
	then
	echo " Vous avez bien entrer un entier"
	else
	echo "Veuiller entrer un entier"
	fi
	;;
l)
	banqueprotlist="$OPTARG"
	listedeprot=$(grep '>' $banqueprotlist | cut -d '>' -f 2)
	echo "$listedeprot"
	read -p "Sur quelle protéine voulez vous travailler ? :" protsolo
	grep -w "$protsolo" $banqueprotlist
	verprotsolo=$(echo $?)
	if
	(("$verprotsolo" == "0"))
	then
	echo " votre protéine est bien dans la liste, le script demarre"
	else
	echo " selectionner une protéine de la liste "
	fi
	;;
u)
	protéine="$OPTARG"
	;;
e)
	evalue="$OPTARG"
	;;
F)
	yornfpkm="$OPTARG"
	;;
T)
	txfpkm="$OPTARG"
	if [[ $OPTARG = +([0-9]) ]]
	then
	echo " Vous avez bien entrer un entier"
	else
	echo "Veuiller entrer un entier"
	fi
	
	;;
\?)
echo "$OPTARG:option invalide"
echo "tapez -H pour voir le menu d'aide " 
	;;

esac
#~ echo "$#"
#~ VERIFICATION
#~ if
#~ (( $option == "b" ))
#~ then
#~ $cheminseqtk/tblastn 2>/dev/null
#~ verblast=$(echo $?)
#~ if
#~ (( "verblast" == "1" ))
#~ then
#~ echo "Vous avez bien renseigné le chemin de blast "
#~ else
#~ echo "Votre chemin vers blast est faux"
#~ fi
#~ fi

#~ if
#~ (( $option == "s" ))
#~ then
#~ $cheminblast/seqtk 2>/dev/null
#~ verseqtk=$(echo $?)
#~ if
#~ (( "verseqtk" == "1" ))
#~ then
#~ echo "Vous avez bien renseigné le chemin de seqtk "
#~ else
#~ echo "Votre chemin vers seqtk est faux"
#~ fi
#~ fi

done



#~ if 
#~ [[ ("$yornfpkm" != "Y") && ("$yornfpkm" != "N") ]]
#~ then
#~ echo "Mauvais arguments utilisés avec l'option -F, si vous voulez utiliser les valeurs de FPKM taper Y(valeur par défaut), sinon tapez N"
#~ fi

#~ if 
#~ $txevalue
#~ echo "ca roule"

#~ echo "vous allez lancer le programme en utilisant $banqueprot comme  banque protéique $transcriptome comme transcriptome  $fichierFPKM comme fichier FPKM  $chemindomaine comme banques de domaines"
#~ echo "Les chemins des programmes sont $cheminblast pour BLAST $cheminheammer pour hmmer et $cheminseqtk pour seqtk "





#~ confirm()
#~ {
	#~ read -r -p "${1} [Y/N] " reponse 
	
	#~ case "$reponse" in
		#~ [yY][eE][sS]|[yY])
		#~ true
		#~ ;;
	#~ *)
		#~ false
		#~ ;;
	#~ esac
#~ }

#~ if confirm " Vous êtres sur de vouloir continuer avec ces arguments ?"; then 
	#~ echo "Parfait!"
#~ else
	#~ echo " Vous pouvez refaire votre commande "
#~ fi
exit 0


#~ /opt/blast/ncbi-blast-2.12.0+/bin/makeblastdb -in sfp1 -dbtype prot
#~ /opt/blast/ncbi-blast-2.12.0+/bin/tblastn -query sfp1 -db Hf_int_All-Unigene.fa -evalue 1e-10 -outfmt "6 delim= sseqid evalue length" -out sfp1bash.blast
















