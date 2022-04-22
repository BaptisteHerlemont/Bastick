#! /bin/bash
nmbprot=$(awk '{print$1}' allprot.blast | sort | uniq |wc -l)
echo "nombre de protéines dans la banque : $nmbprot" >> resultatglobal
nomprot=$(awk '{print$1}' allprot.blast|sort|uniq)
echo "noms des protéines allignées :
$nomprot"  >> resultatglobal

listedeprot=$(awk '{print$1}' allprot.blast |sort|uniq)
for prot in $listedeprot
do
echo " 
pour la protéine : $prot" >> resultatglobal

nmbrblast=$(grep -w "$prot" allprot.blast | awk '{print$2}'|sort|uniq|wc -l)

echo "
Nombre Hits BLAST : $nmbrblast" >> resultatglobal

nmbralign=$(awk '{print$1}' allprot.blast | grep -w "$prot" |wc -l)

echo "
Nombre d'alignements : $nmbralign" >> resultatglobal

nmbrtran=$(wc -l $prot.lesbonsventros|awk '{print$1}')

echo "
Nombre transcrits avec FPKM > 2 : $nmbrtran" >> resultatglobal

nmbrdom=$(wc -l resultat.$prot.domain|awk '{print$1}')

echo "
La protéine $prot a $nmbrdom domaines"  >> resultatglobal

dom=$(cat resultat.$prot.domain)

echo "Les domaines sont : 

$dom
" >> resultatglobal

nmbrdomcomm=$(ls -ltr | grep "domainencommun" | grep -w "$prot" | awk '{print$9}' | cut -f 3 -d .|sort|uniq|wc -l)

echo "
Sur les $nmbrtran , il y a $nmbrdomcomm qui ont au moins 1 domaine en commun  : " >> resultatglobal

nomdomcomm=$(ls -ltr | grep "domainencommun" | grep -w "$prot" | awk '{print$9}' | cut -f 3 -d .|sort|uniq)

echo "$nomdomcomm" >> resultatglobal

done

