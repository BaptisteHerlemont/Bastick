#! /bin/bash

#~ VARIABLE PAR DEFAUTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT

#~ valeur par defaut du nombre de cpu 
nmbcpu="2"
#~ valuer par defaut de la evalue
evalue="1e-10"
#~ valeur par defaut du tx dexpression des valeurs FPKM
txfpkm="2"
#~ valeur par defaut du nom fichier resultat
fichiersortie="resultatglobal"
yornfpkm="Y"


#~ CLIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII

while getopts ":t:f:b:s:h:d:n:e:F:THl:o:" option
do
echo "Pour l'option $option:"
case $option in 

t)
	transcriptome="$OPTARG"
	grep argumentsurementpaspresent $transcriptome 2>/dev/null
	vertrans=$(echo $?)
	if
	(( "$vertrans" == "2" ))
	then
	echo "Attention, votre transcriptome n'éxiste pas "
	else
	transcriptomerenseigne="1"
	echo "Votre transcriptome existe bien"
	fi
	;;
f)
	fichierFPKM="$OPTARG"
	grep argumentsurementpaspresent $fichierFPKM 2>/dev/null
	verfpkmfichier=$(echo $?)
	if
	(( "$verfpkmfichier" == "2" ))
	then
	echo "Attention, votre fichier FPKM n'éxiste pas "
	else
	fichierfpkmrenseigne=1
	echo "Votre fichier FPKM existe bien"
	fi
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
	seqtkok=2
	fi
	;;
o)
	fichiersortie="$OPTARG"
	echo "$fichierdesortie"
	grep argumentsurementpaspresent $fichiersortie 2>/dev/null
	verstdout=$(echo $?)
	if
	(( "$verstdout" == "2" ))
	then
	echo "Nom valide"
	else
	echo "Attention, fichier deja existant, veuillez sélectionner un nom non utilisé"
	exit
	fi
	;;
d)
	domaine="$OPTARG"
	grep argumentsurementpaspresent $domaine 2>/dev/null
	verdom=$(echo $?)
	if
	(( "$verdom" == "1" ))
	then
	domainerenseigne=1
	echo "Votre fichier domaine existe bien "
	else
	echo "Attention, votre fichier de domaine n'existe pas"
	#~ exit
	fi
	;;
n)
	nmbcpu="$OPTARG"
	if [[ $OPTARG = +([0-9]) ]]
	then
	echo " Vous avez bien entré un entier"
	else
	echo "Veuillez entrer un entier"
	fi
	;;
e)
	evalue="$OPTARG"
	;;
T)
	txfpkm="$OPTARG"
	if [[ $OPTARG = +([0-9]) ]]
	then
	echo " Vous avez bien entré un entier"
	else
	echo "Veuillez entrer un entier"
	fi
	
	;;
H)
	echo "ARGUMENTS OBLIGATOIRES
-l     			STRING			affiche la liste des protéines de la banque sélectionnée et offre la possibilité de lancer le programme sur une protéine de la liste 
-t			STRING			pour indiquer le transcriptome
-f			STRING			pour indiquer le fichier avec les valeurs FPKM au format CSV 
-b			STRING			pour indiquer le chemin de BLAST
-s			STRING			pour indiquer le chemin de seqkt
-d			STRING			pour indiquer la banque de domaine 
ARGUMENTS OPTIONNELS
-h			STRING			pour indiquer le chemin de hmmear
-n			INT			pour indiquer le nombre de CPU à utiliser (2par défauts)
-e			INT			pour indiquer la valeur seuil d'e value (1e-10 par defaut)
-F			STRING			pour indiquer si vous voulez utiliser les valeurs de FPKM (N) (Y par defaut)
-T			INT			pour indiquer  le taux d'expression des valeurs FPKM à utiliser ( 2 par défaut )
-o			STRING			pour indiquer le nom du fichier de sortie
-H						affiche ce menu d'aide"


	;;
l)
	banqueprotlist="$OPTARG"
	grep argumentsurementpaspresent $banqueprotlist 2>/dev/null
	verbankprot=$(echo $?)
	if
	(( "$verbankprot" == "2" ))
	then
	echo "Attention, votre banque n'éxiste pas "
	else
	sed -i s/' '/'_'/g $banqueprotlist
	listedeprot=$(grep '>' $banqueprotlist | cut -d '>' -f 2)
	banquerenseignee="1"
	echo "Votre banque existe bien"
	echo "$listedeprot"
	read -p "Sur quelle protéine voulez vous travailler ? :" protsolo
	grep -w "$protsolo" $banqueprotlist
	verprotsolo=$(echo $?)
	if
	(("$verprotsolo" == "0"))
	then
	protosoloo="2"
	nomprotsolo="$protsolo"
	echo " votre protéine est bien dans la liste"
	else
	echo " selectionner une protéine de la liste "
	exit
	fi
	fi
	;;
\?)
echo "$OPTARG:option invalide"
echo "tapez -H pour voir le menu d'aide " 
	;;
esac
done

if 
(("$banquerenseignee" == "1" && "$transcriptomerenseigne" == "1" && "$blastok" == "1" && "$seqtkok" == "1" && "$domainerenseigne" == "1" && "$fichierfpkmrenseigne" =="1"  )) 2>/dev/null
then
echo "Vous avez renseigné tous les arugments obligatoires, le programme démarre"



sed 's/;/ /g' $fichierFPKM > Copieespace.csv
awk '{print$1,$7}' Copieespace.csv > Copie2col.csv
cp $transcriptome .
$cheminblast/makeblastdb -in $transcriptome -dbtype nucl 1>/dev/null
$cheminseqtk/seqtk seq $transcriptome > transcriptome.fq
$cheminseqtk/seqtk seq $banqueprotlist > banqueprot.fq
grep -A1 -w "$nomprotsolo" banqueprot.fq > $nomprotsolo.fasta
$cheminblast/makeblastdb -in $nomprotsolo.fasta -dbtype prot 1>/dev/null
veretapeblast=$(echo $?)
if
(("$veretapeblast"=="1"))
then
exit 
fi

$cheminblast/tblastn -query $nomprotsolo.fasta -db $transcriptome -evalue "$evalue" -outfmt "6 delim= sseqid evalue length" -out $nomprotsolo.blast  
cat $nomprotsolo.blast | sort -k1 > $nomprotsolo.etape1bash
hmmsearch --tblout $nomprotsolo.domain --cpu $nmbcpu $domaine $nomprotsolo.fasta 1>/dev/null
verhmmergood=$(echo $?)
if 
(("$verhmmergood" != "0" ))
then
echo "Problémes rencontrés au niveau de Hmmer"
exit
fi

echo " Pour la $nomprotsolo , la recherche de ces domaines est faite"
sed '/^#/d' -i $nomprotsolo.domain
awk '{print$3}' $nomprotsolo.domain > resultat.$nomprotsolo.domain
sort resultat.$nomprotsolo.domain > resultat.$nomprotsolo.domainsort
nomtranscrits=$(awk '{print$1}' $nomprotsolo.etape1bash |uniq)
echo "$nomtranscrits" > $nomprotsolo.resultat.blast
for transcrits in $nomtranscrits
do
grep -A1 -w "$transcrits" transcriptome.fq >> blast.fasta.resultat.$nomprotsolo
grep -w "$transcrits" Copie2col.csv >> $nomprotsolo.FPKMtranscrits
sort -nk2 $nomprotsolo.FPKMtranscrits > $nomprotsolo.FPKMtranscrits.sort
awk '{print$2}' $nomprotsolo.FPKMtranscrits.sort > $nomprotsolo.FPKMtranscrits.sort2
sed 'y/,/./' $nomprotsolo.FPKMtranscrits.sort2 > $nomprotsolo.FPKMtranscrits.sort2point
awk '{if ($1 > 2) print$0}' $nomprotsolo.FPKMtranscrits.sort2point  > $nomprotsolo.lesbonsventro
sed 'y/./,/' $nomprotsolo.lesbonsventro > $nomprotsolo.lesbonsventrovirgule
while IFS= read -r line 
do
grep $line $nomprotsolo.FPKMtranscrits >> $nomprotsolo.allventronom
done < $nomprotsolo.lesbonsventrovirgule
done
awk '{print$1}' $nomprotsolo.allventronom|sort|uniq > $nomprotsolo.lesbonsventros
cat $nomprotsolo.lesbonsventros > $nomprotsolo.resultat.FPKM
goodventral=$(cat $nomprotsolo.lesbonsventros)
for ventral in $goodventral
do
nomtaillealign=$(grep $ventral $nomprotsolo.etape1bash| sort -nk3 | head -1 | awk '{print$1,$3}')
grep -A1 -w "$ventral" transcriptome.fq > $nomprotsolo.$ventral.seq
cat $nomprotsolo.$ventral.seq >> $nomprotsolo.FPKM.fasta.resultat
taillealign=$(echo $nomtaillealign | awk '{print$2}')
sixpack $nomprotsolo.$ventral.seq -outfile $nomprotsolo.$ventral.menfou -outseq $nomprotsolo.$ventral.resultatsixpack 2>/dev/null
awk '{print$12}' $nomprotsolo.$ventral.resultatsixpack > $nomprotsolo.$ventral.aalignes
grep 'aa' $nomprotsolo.$ventral.aalignes > $nomprotsolo.$ventral.queaa
sed -e ' s/aa//' $nomprotsolo.$ventral.queaa > $nomprotsolo.$ventral.que
while IFS= read -r line
do
if (("$line" >= "$taillealign"))
then
echo "$line"' '"$ventral" >> $nomprotsolo.$ventral.orfpossibleavectaille
fi
done < $nomprotsolo.$ventral.que
awk '{print$1}' $nomprotsolo.$ventral.orfpossibleavectaille > $nomprotsolo.$ventral.tailleorf
sed 's/$/aa/' $nomprotsolo.$ventral.tailleorf > $nomprotsolo.$ventral.tailleorfaa
$cheminseqtk/seqtk seq $nomprotsolo.$ventral.resultatsixpack > $nomprotsolo.$ventral.resultatsixpackfastq
cat $nomprotsolo.$ventral.tailleorfaa | sort -n | uniq -c > $nomprotsolo.$ventral.tailleorfaacount
awk '{print$1}' $nomprotsolo.$ventral.tailleorfaacount > $nomprotsolo.$ventral.tailleorfaacountrep
awk -F\  '{print$2}' $nomprotsolo.$ventral.tailleorfaacount > $nomprotsolo.$ventral.tailleorfaacounttaille
while IFS= read -r line
do
grep -A1 $line $nomprotsolo.$ventral.resultatsixpackfastq > $nomprotsolo.$ventral.$line.seqorf
#~ #A REVOIR cat $nomprotsolo.$ventral.$line.seqorf >> $nomprotsolo.resultat.$ventral.orf.fasta A REVOIR 
#~ #A REVOIR ~ cat $nomprotsolo.resultat.$ventral.orf.fasta > $nomprotsolo.resultat.allorf.fasta   A REVOIR 
nmblignesorf=$(cat $nomprotsolo.$ventral.$line.seqorf|wc -l)
if
(("$nmblignesorf" != "2" ))
then
awk 'NR>0 && NR<3' $nomprotsolo.$ventral.$line.seqorf > $nomprotsolo.$ventral.$line.seqorf.1
hmmsearch --tblout $nomprotsolo.$ventral.$line.domain.1 --cpu "$nmbcpu" $domaine $nomprotsolo.$ventral.$line.seqorf.1 1>/dev/null
sed '/^#/d' -i $nomprotsolo.$ventral.$line.domain.1
awk '{print$3}' $nomprotsolo.$ventral.$line.domain.1 > $nomprotsolo.$ventral.$line.domainsolo.1
compteurdeligne1=$(wc -l $nomprotsolo.$ventral.$line.domainsolo.1| awk '{print$1}')
if
(("$compteurdeligne1" != "0" ))
then
sort $nomprotsolo.$ventral.$line.domainsolo.1 > $nomprotsolo.$ventral.$line.domainsolo.sort.1 
comm -12 resultat.$nomprotsolo.domainsort $nomprotsolo.$ventral.$line.domainsolo.sort.1 | awk 'BEGIN {FS=":|\t"} {print $1}' | awk '!/^$/' > resultat.$nomprotsolo.$ventral.$line.domainencommun.1
fi


awk 'NR>3 && NR<6' $nomprotsolo.$ventral.$line.seqorf > $nomprotsolo.$ventral.$line.seqorf.2
hmmsearch --tblout $nomprotsolo.$ventral.$line.domain.2 --cpu "$nmbcpu" $domaine $nomprotsolo.$ventral.$line.seqorf.2 1>/dev/null
sed '/^#/d' -i $nomprotsolo.$ventral.$line.domain.2
awk '{print$3}' $nomprotsolo.$ventral.$line.domain.2 > $nomprotsolo.$ventral.$line.domainsolo.2
compteurdeligne2=$(wc -l $nomprotsolo.$ventral.$line.domainsolo.2| awk '{print$1}')
if
(("$compteurdeligne2" != "0" ))
then
sort $nomprotsolo.$ventral.$line.domainsolo.2 > $nomprotsolo.$ventral.$line.domainsolo.sort.2
comm -12 resultat.$nomprotsolo.domainsort $nomprotsolo.$ventral.$line.domainsolo.sort.2 | awk 'BEGIN {FS=":|\t"} {print $1}' | awk '!/^$/' > resultat.$nomprotsolo.$ventral.$line.domainencommun.2
fi


awk 'NR>6 && NR<9' $nomprotsolo.$ventral.$line.seqorf > $nomprotsolo.$ventral.$line.seqorf.3
hmmsearch --tblout $nomprotsolo.$ventral.$line.domain.3 --cpu "$nmbcpu" $domaine $nomprotsolo.$ventral.$line.seqorf.3 1>/dev/null
sed '/^#/d' -i $nomprotsolo.$ventral.$line.domain.3
awk '{print$3}' $nomprotsolo.$ventral.$line.domain.3 > $nomprotsolo.$ventral.$line.domainsolo.3
compteurdeligne3=$(wc -l $nomprotsolo.$ventral.$line.domainsolo.3| awk '{print$1}')
if
(("$compteurdeligne3" != "0" ))
then
sort $nomprotsolo.$ventral.$line.domainsolo.3 > $nomprotsolo.$ventral.$line.domainsolo.sort.3
comm -12 resultat.$nomprotsolo.domainsort $nomprotsolo.$ventral.$line.domainsolo.sort.3 | awk 'BEGIN {FS=":|\t"} {print $1}' | awk '!/^$/' > resultat.$nomprotsolo.$ventral.$line.domainencommun.3
fi
fi

hmmsearch --tblout $nomprotsolo.$ventral.$line.domain --cpu "$nmbcpu" $domaine $nomprotsolo.$ventral.$line.seqorf 1>/dev/null

sed '/^#/d' -i $nomprotsolo.$ventral.$line.domain
awk '{print$3}' $nomprotsolo.$ventral.$line.domain > $nomprotsolo.$ventral.$line.domainsolo

compteurdeligne=$(wc -l $nomprotsolo.$ventral.$line.domainsolo | awk '{print$1}')
if
(("$compteurdeligne" != "0" ))
then
sort $nomprotsolo.$ventral.$line.domainsolo > $nomprotsolo.$ventral.$line.domainsolo.sort 
comm -12 resultat.$nomprotsolo.domainsort $nomprotsolo.$ventral.$line.domainsolo.sort > resultat.$nomprotsolo.$ventral.$line.domainencommun
fi

if 
test -s resultat.$nomprotsolo.$ventral.$line.domainencommun
then 
echo "$nomprotsolo" "$ventral" >> ensembledesprotetventralavecdomencomm
fi
if 
test -s resultat.$nomprotsolo.$ventral.$line.domainencommun.1
then 
echo "$nomprotsolo" "$ventral" >> ensembledesprotetventralavecdomencomm
fi
if 
test -s resultat.$nomprotsolo.$ventral.$line.domainencommun.2
then 
echo "$nomprotsolo" "$ventral" >> ensembledesprotetventralavecdomencomm
fi
if 
test -s resultat.$nomprotsolo.$ventral.$line.domainencommun.3
then 
echo "$nomprotsolo" "$ventral" >> ensembledesprotetventralavecdomencomm
fi

done < $nomprotsolo.$ventral.tailleorfaacounttaille


echo " Pour la $nomprotsolo, la comparaison de ces domaines avec les transcrits est faite " 
done


#~ #RESULTATTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT


echo " 
pour la protéine : $nomprotsolo" >> "$fichiersortie"

nmbrblast=$(awk '{print$1}' $nomprotsolo.blast |sort|uniq|wc -l)

echo "
Nombre Hits BLAST : $nmbrblast" >> "$fichiersortie"

nmbralign=$(awk '{print$1}' $nomprotsolo.blast  |wc -l)

echo "
Nombre d'alignements : $nmbralign" >> "$fichiersortie"

nmbrtran=$(wc -l $nomprotsolo.lesbonsventros|awk '{print$1}')

echo "
Nombre transcrits avec FPKM > 2 : $nmbrtran" >> ""$fichiersortie""

nmbrdom=$(wc -l resultat.$nomprotsolo.domain|awk '{print$1}')

echo "
La protéine $nomprotsolo a $nmbrdom domaines"  >> "$fichiersortie"

dom=$(cat resultat.$nomprotsolo.domain)

echo "Les domaines sont : 

$dom
" >> "$fichiersortie"

nmbrtrandom=$(grep -w "$nomprotsolo" ensembledesprotetventralavecdomencomm |awk '{print$2}'|sort|uniq|wc -l)
echo " Sur les $nmbrtran transcrits gardés, il y en a $nmbrtrandom avec au moins 1 domaine en commun " >> "$fichiersortie"

nomtrandom=$(grep -w "$nomprotsolo" ensembledesprotetventralavecdomencomm |awk '{print$2}'|sort |uniq)

for traneval in $nomtrandom 
do
grep -w "$traneval" $nomprotsolo.FPKMtranscrits >> fichiertempofpkm.$nomprotsolo
grep -w "$traneval"  $nomprotsolo.blast | awk '{print$1,$2}'|sort -gk2|head -1 >>fichiertempotranseteval
grep "$traneval" fichiertempofpkm.$nomprotsolo >> final.$nomprotsolo
done

transeteval=$(awk '{print$1,$2}' fichiertempotranseteval | sort -gk2)


echo " 
Voici la liste de ces transcrits classés par ordre d'evalue : 
$transeteval 
" >> "$fichiersortie"


valfpkm=$(sort -nrk2 final.$nomprotsolo)
echo "Voici la liste de ces transcrits classés selon le rapport ventral/dorsal :
$valfpkm" >> "$fichiersortie"

else
echo "1 ou plusieurs aurguments sont manquants" 
fi


#~ NETOYAGEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

rm -f protalign
rm -f protbank
rm -f final.*
rm -f fichiertempotranseteval
rm -f fichiertempofpkm.*
rm -f fichiertempoofpkm
rm -f ensembledesprotetventralavecdomencomm
rm -f *.domainsolo
rm -f *.domainsolo.sort
rm -f *.domainencommun
rm -f *.domain
rm -f *.seqorf
rm -f *.aalignes
rm -f *.orfpossibleavectaille
rm -f *.que
rm -f *.queaa
rm -f *.resultatsixpackfastq
rm -f *.tailleorf
rm -f *.tailleorfaa
rm -f *.tailleorfaacount
rm -f *.tailleorfaacountrep
rm -f *.tailleorfaacounttaille
rm -f *.menfou
rm -f *.resultatsixpack
rm -f *.resultat
rm -f *.seq
rm -f *.lesbonsventros
rm -f *.FPKM
rm -f *.sort
rm -f *.sort2
rm -f *.sort2point
rm -f *.allventronom
rm -f *.lesbonsventrovirgule
rm -f *.lesbonsventro
rm -f *.FPKMtranscrits
rm -f *.domainsort
rm -f *.1
rm -f *.2
rm -f *.3
rm -f *.psq
rm -f *.pin
rm -f *.phr
rm -f *.pdb
rm -f *.pto
rm -f *.ptf
rm -f *.pot
rm -f *.nsq
rm -f *.nin
rm -f *.nhr
rm -f *.ndb
rm -f *.nto
rm -f *.ntf
rm -f *.not
rm -f *.blast 
rm -f *.etape1bash 
rm blast.*
rm -f *.fasta
rm -f *.fa
rm -f *.fq 
rm -f *.csv

