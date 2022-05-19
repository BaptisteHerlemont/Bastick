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

#~ CLIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII

while getopts ":p:t:f:b:s:h:d:n:e:F:THo" option
do
echo "getops a trouvé l'option $option"
case $option in 
p)
	banqueprot="$OPTARG"
	grep argumentsurementpaspresent $banqueprot 2>/dev/null
	verbankprot=$(echo $?)
	if
	(( "$verbankprot" == "2" ))
	then
	echo "Attention, votre banque n'éxiste pas "
	else
	sed -i s/' '/'_'/g $banqueprot
	banquerenseignee="1"
	echo "Votre banque existe bien"
	fi
	;;
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
-T			INT			pour indiquer  le taux d'expression des valeurs FPKM à utiliser ( 2 par défaut )
-H						affiche ce menu d'aide
-o			STRING			pour indiquer le nom du fichier de sortie"

	;;

esac
done

#~ PROGRAMMEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

if 
(("$banquerenseignee" == "1" && "$transcriptomerenseigne" == "1" && "$blastok" == "1" && "$seqtkok" == "1" && "$domainerenseigne" == "1" && "$fichierfpkmrenseigne" =="1"  )) 2>/dev/null
then
echo "Vous avez renseigné tous les arugments obligatoires, le programme démarre"


sed 's/;/ /g' $fichierFPKM > Copieespace.csv
awk '{print$1,$7}' Copieespace.csv > Copie2col.csv
cp $transcriptome .
$cheminblast/makeblastdb -in $transcriptome -dbtype nucl 1>/dev/null
$cheminseqtk/seqtk seq $transcriptome > Hf_int_All-Unigene.fq
$cheminblast/makeblastdb -in $banqueprot -dbtype prot 1>/dev/null
$cheminblast/tblastn -query $banqueprot -db $transcriptome -evalue "$evalue" -outfmt "6 delim= qseqid sseqid evalue length" -out allprot.blast  
veretapeblast=$(echo $?)
if
(("$veretapeblast"=="1"))
then
exit 
fi
listedeprot=$(awk '{print$1}' allprot.blast |sort|uniq)
for prot in $listedeprot
do
grep -A1 -w $prot $banqueprot > $prot.fasta
$cheminblast/makeblastdb -in $prot.fasta -dbtype prot 
$cheminblast/tblastn -query $prot.fasta -db $transcriptome -evalue "$evalue" -outfmt "6 delim= sseqid evalue length" -out $prot.blast  
cat $prot.blast | sort -k1 > $prot.etape1bash
hmmsearch --tblout $prot.domain --cpu "$nmbcpu" $domaine $prot.fasta 1>/dev/null
verhmmergood=$(echo $?)
if 
(("$verhmmergood" != "0" ))
then
exit
fi

echo " Pour la $prot , la recherche de ces domaines est faite"
sed '/^#/d' -i $prot.domain
awk '{print$3}' $prot.domain > resultat.$prot.domain
sort resultat.$prot.domain > resultat.$prot.domainsort
nomtranscrits=$(awk '{print$1}' $prot.etape1bash |uniq)
echo "$nomtranscrits" > $prot.resultat.blast
for transcrits in $nomtranscrits
do
grep -A1 $transcrits Hf_int_All-Unigene.fq >> blast.fasta.resultat.$prot
grep $transcrits Copie2col.csv >> $prot.FPKMtranscrits
sort -nk2 $prot.FPKMtranscrits > $prot.FPKMtranscrits.sort
awk '{print$2}' $prot.FPKMtranscrits.sort > $prot.FPKMtranscrits.sort2
sed 'y/,/./' $prot.FPKMtranscrits.sort2 > $prot.FPKMtranscrits.sort2point
awk '{if ($1 > "$txfpkm") print$0}' $prot.FPKMtranscrits.sort2point  > $prot.lesbonsventro
sed 'y/./,/' $prot.lesbonsventro > $prot.lesbonsventrovirgule
while IFS= read -r line 
do
grep $line $prot.FPKMtranscrits >> $prot.allventronom
done < $prot.lesbonsventrovirgule
done
awk '{print$1}' $prot.allventronom|sort|uniq > $prot.lesbonsventros
cat $prot.lesbonsventros > $prot.resultat.FPKM
goodventral=$(cat $prot.lesbonsventros)
for ventral in $goodventral
do
nomtaillealign=$(grep $ventral $prot.etape1bash| sort -nk3 | head -1 | awk '{print$1,$3}')
grep -A1 $ventral Hf_int_All-Unigene.fq > $prot.$ventral.seq
cat $prot.$ventral.seq >> $prot.FPKM.fasta.resultat
taillealign=$(echo $nomtaillealign | awk '{print$2}')
sixpack $prot.$ventral.seq -outfile $prot.$ventral.menfou -outseq $prot.$ventral.resultatsixpack 2>/dev/null
awk '{print$12}' $prot.$ventral.resultatsixpack > $prot.$ventral.aalignes
grep 'aa' $prot.$ventral.aalignes > $prot.$ventral.queaa
sed -e ' s/aa//' $prot.$ventral.queaa > $prot.$ventral.que
while IFS= read -r line
do
if (("$line" >= "$taillealign"))
then
echo "$line"' '"$ventral" >> $prot.$ventral.orfpossibleavectaille
fi
done < $prot.$ventral.que
awk '{print$1}' $prot.$ventral.orfpossibleavectaille > $prot.$ventral.tailleorf
sed 's/$/aa/' $prot.$ventral.tailleorf > $prot.$ventral.tailleorfaa
$cheminseqtk/seqtk seq $prot.$ventral.resultatsixpack > $prot.$ventral.resultatsixpackfastq
cat $prot.$ventral.tailleorfaa | sort -n | uniq -c > $prot.$ventral.tailleorfaacount
awk '{print$1}' $prot.$ventral.tailleorfaacount > $prot.$ventral.tailleorfaacountrep
awk -F\  '{print$2}' $prot.$ventral.tailleorfaacount > $prot.$ventral.tailleorfaacounttaille
while IFS= read -r line
do
grep -A1 $line $prot.$ventral.resultatsixpackfastq > $prot.$ventral.$line.seqorf
#~ #A REVOIR cat $prot.$ventral.$line.seqorf >> $prot.resultat.$ventral.orf.fasta A REVOIR 
#~ #A REVOIR ~ cat $prot.resultat.$ventral.orf.fasta > $prot.resultat.allorf.fasta   A REVOIR 
nmblignesorf=$(cat $prot.$ventral.$line.seqorf|wc -l)
if
(("$nmblignesorf" != "2" ))
then
awk 'NR>0 && NR<3' $prot.$ventral.$line.seqorf > $prot.$ventral.$line.seqorf.1
hmmsearch --tblout $prot.$ventral.$line.domain.1 --cpu "$nmbcpu" $domaine $prot.$ventral.$line.seqorf.1 1>/dev/null
sed '/^#/d' -i $prot.$ventral.$line.domain.1
awk '{print$3}' $prot.$ventral.$line.domain.1 > $prot.$ventral.$line.domainsolo.1
compteurdeligne1=$(wc -l $prot.$ventral.$line.domainsolo.1| awk '{print$1}')
if
(("$compteurdeligne1" != "0" ))
then
sort $prot.$ventral.$line.domainsolo.1 > $prot.$ventral.$line.domainsolo.sort.1 
comm -12 resultat.$prot.domainsort $prot.$ventral.$line.domainsolo.sort.1 | awk 'BEGIN {FS=":|\t"} {print $1}' | awk '!/^$/' > resultat.$prot.$ventral.$line.domainencommun.1
fi


awk 'NR>3 && NR<6' $prot.$ventral.$line.seqorf > $prot.$ventral.$line.seqorf.2
hmmsearch --tblout $prot.$ventral.$line.domain.2 --cpu "$nmbcpu" $domaine $prot.$ventral.$line.seqorf.2 1>/dev/null
sed '/^#/d' -i $prot.$ventral.$line.domain.2
awk '{print$3}' $prot.$ventral.$line.domain.2 > $prot.$ventral.$line.domainsolo.2
compteurdeligne2=$(wc -l $prot.$ventral.$line.domainsolo.2| awk '{print$1}')
if
(("$compteurdeligne2" != "0" ))
then
sort $prot.$ventral.$line.domainsolo.2 > $prot.$ventral.$line.domainsolo.sort.2
comm -12 resultat.$prot.domainsort $prot.$ventral.$line.domainsolo.sort.2 | awk 'BEGIN {FS=":|\t"} {print $1}' | awk '!/^$/' > resultat.$prot.$ventral.$line.domainencommun.2
fi


awk 'NR>6 && NR<9' $prot.$ventral.$line.seqorf > $prot.$ventral.$line.seqorf.3
hmmsearch --tblout $prot.$ventral.$line.domain.3 --cpu "$nmbcpu" $domaine $prot.$ventral.$line.seqorf.3 1>/dev/null
sed '/^#/d' -i $prot.$ventral.$line.domain.3
awk '{print$3}' $prot.$ventral.$line.domain.3 > $prot.$ventral.$line.domainsolo.3
compteurdeligne3=$(wc -l $prot.$ventral.$line.domainsolo.3| awk '{print$1}')
if
(("$compteurdeligne3" != "0" ))
then
sort $prot.$ventral.$line.domainsolo.3 > $prot.$ventral.$line.domainsolo.sort.3
comm -12 resultat.$prot.domainsort $prot.$ventral.$line.domainsolo.sort.3 | awk 'BEGIN {FS=":|\t"} {print $1}' | awk '!/^$/' > resultat.$prot.$ventral.$line.domainencommun.3
fi
fi

hmmsearch --tblout $prot.$ventral.$line.domain --cpu "$nmbcpu" $domaine $prot.$ventral.$line.seqorf 1>/dev/null

sed '/^#/d' -i $prot.$ventral.$line.domain
awk '{print$3}' $prot.$ventral.$line.domain > $prot.$ventral.$line.domainsolo

compteurdeligne=$(wc -l $prot.$ventral.$line.domainsolo | awk '{print$1}')
if
(("$compteurdeligne" != "0" ))
then
sort $prot.$ventral.$line.domainsolo > $prot.$ventral.$line.domainsolo.sort 
comm -12 resultat.$prot.domainsort $prot.$ventral.$line.domainsolo.sort > resultat.$prot.$ventral.$line.domainencommun
fi

if 
test -s resultat.$prot.$ventral.$line.domainencommun
then 
echo "$prot" "$ventral" >> ensembledesprotetventralavecdomencomm
fi
if 
test -s resultat.$prot.$ventral.$line.domainencommun.1
then 
echo "$prot" "$ventral" >> ensembledesprotetventralavecdomencomm
fi
if 
test -s resultat.$prot.$ventral.$line.domainencommun.2
then 
echo "$prot" "$ventral" >> ensembledesprotetventralavecdomencomm
fi
if 
test -s resultat.$prot.$ventral.$line.domainencommun.3
then 
echo "$prot" "$ventral" >> ensembledesprotetventralavecdomencomm
fi

done < $prot.$ventral.tailleorfaacounttaille


done
echo " Pour la $prot, la comparaison de ces domaines avec les transcrits est faite " 
done


#~ RESULTATTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT

nmbrprotbanque=$(grep '>' $banqueprot |wc -l)
echo " Il y a $nmbrprotbanque protéines dans la banque" >> $fichiersortie

nmbprot=$(awk '{print$1}' allprot.blast | sort | uniq |wc -l)
echo "Nombre de protéines avec au moins 1 alignement : $nmbprot" >> $fichiersortie

nmbrdiffprot=$(($nmbrprotbanque-$nmbprot))
echo " Il y a donc $nmbrdiffprot protéines qui ne sont pas alignées :
" >>$fichiersortie

awk '{print$1}' allprot.blast|sort|uniq|sort > protalign

grep '>' $banqueprot| cut -d '>' -f 2|sort > protbank

dos2unix prot*
nomdiffprot=$(cat protalign protbank | sort |uniq -u)
echo "$nomdiffprot" >>$fichiersortie

nomprotalign=$(awk '{print$1}' allprot.blast|sort|uniq)
echo "Noms des protéines allignées :
$nomprotalign"  >> $fichiersortie

awk '{print$1}' allprot.blast|sort|uniq > protalign





for prot in $nomprotalign
do
echo " 
pour la protéine : $prot" >> $fichiersortie

nmbrblast=$(grep -w "$prot" allprot.blast | awk '{print$2}'|sort|uniq|wc -l)

echo "
Nombre Hits BLAST : $nmbrblast" >> $fichiersortie

nmbralign=$(awk '{print$1}' allprot.blast | grep -w "$prot" |wc -l)

echo "
Nombre d'alignements : $nmbralign" >> $fichiersortie

nmbrtran=$(wc -l $prot.lesbonsventros|awk '{print$1}')

echo "
Nombre transcrits avec FPKM > 2 : $nmbrtran" >> $fichiersortie

nmbrdom=$(wc -l resultat.$prot.domain|awk '{print$1}')

echo "
La protéine $prot a $nmbrdom domaines"  >> $fichiersortie

dom=$(cat resultat.$prot.domain)

echo "Les domaines sont : 

$dom
" >> $fichiersortie

nmbrtrandom=$(grep -w "$prot" ensembledesprotetventralavecdomencomm |awk '{print$2}'|sort|uniq|wc -l)
echo " Sur les $nmbrtran transcrits gardés, il y en a $nmbrtrandom avec au moins 1 domaine en commun " >> $fichiersortie

nomtrandom=$(grep -w "$prot" ensembledesprotetventralavecdomencomm |awk '{print$2}'|sort |uniq)

for traneval in $nomtrandom 
do
grep -w "$traneval" $prot.FPKMtranscrits >> fichiertempofpkm.$prot
grep -w "$prot" allprot.blast|grep -w "$traneval"  | awk '{print$1,$2,$3}'|sort -gk2|head -1 >>fichiertempotranseteval
grep "$traneval" fichiertempofpkm.$prot >> final.$prot
done

transeteval=$(grep -w "$prot" fichiertempotranseteval| awk '{print$2,$3}' | sort -gk2)


echo " 
Voici la liste de ces transcrits classés par ordre d'evalue : 
$transeteval 
" >> $fichiersortie


valfpkm=$(sort -nrk2 final.$prot)
echo "Voici la liste de ces transcrits classés selon le rapport ventral/dorsal :
$valfpkm" >> $fichiersortie
done

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
rm -f blast.*
rm -f *.fasta
rm -f *.fa
rm -f *.fq 
rm -f *.csv
