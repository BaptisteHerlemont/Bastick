#! /bin/bash

#~ CLIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII

#~ while getopts ":p:t:f:b:s:d:Hl:u:F:n:e:" option
#~ do
#~ echo "getops a trouvé l'option $option"
#~ case $option in 
#~ p)
	#~ banque="$OPTARG"
	#~ ;;
#~ esac
#~ done

#~ PROGRAMMEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE


#~ sed 's/;/ /g' /home/baptiste/bOMBSTAGE2022/FPKM/Copie_de_Supplementary_Table_S2_Global_Annotation.csv > Copieespace.csv
#~ awk '{print$1,$7}' Copieespace.csv > Copie2col.csv
#~ cp /home/baptiste/bOMBSTAGE2022/sequences/Hf_int_All-Unigene.fa .
#~ /opt/blast/ncbi-blast-2.12.0+/bin/makeblastdb -in Hf_int_All-Unigene.fa -dbtype nucl
#~ /opt/seqtk/seqtk seq Hf_int_All-Unigene.fa > Hf_int_All-Unigene.fq
#~ /opt/blast/ncbi-blast-2.12.0+/bin/makeblastdb -in $banque -dbtype prot
#~ /opt/blast/ncbi-blast-2.12.0+/bin/tblastn -query $banque -db Hf_int_All-Unigene.fa -evalue 1e-10 -outfmt "6 delim= qseqid sseqid evalue length" -out allprot.blast
#~ listedeprot=$(awk '{print$1}' allprot.blast |sort|uniq)
#~ for prot in $listedeprot
#~ do
#~ grep -A1 -w $prot $banque > $prot.fasta
#~ /opt/blast/ncbi-blast-2.12.0+/bin/makeblastdb -in $prot.fasta -dbtype prot
#~ /opt/blast/ncbi-blast-2.12.0+/bin/tblastn -query $prot.fasta -db Hf_int_All-Unigene.fa -evalue 1e-10 -outfmt "6 delim= sseqid evalue length" -out $prot.blast
#~ cat $prot.blast | sort -k1 > $prot.etape1bash
#~ hmmsearch --tblout $prot.domain --cpu 16 /opt/pfam/Pfam-A.hmm $prot.fasta
#~ sed '/^#/d' -i $prot.domain
#~ awk '{print$3}' $prot.domain > resultat.$prot.domain
#~ sort resultat.$prot.domain > resultat.$prot.domainsort
#~ nomtranscrits=$(awk '{print$1}' $prot.etape1bash |uniq)
#~ echo "$nomtranscrits" > $prot.resultat.blast
#~ for transcrits in $nomtranscrits
#~ do
#~ grep -A1 $transcrits Hf_int_All-Unigene.fq >> blast.fasta.resultat.$prot
#~ grep $transcrits Copie2col.csv >> $prot.FPKMtranscrits
#~ sort -nk2 $prot.FPKMtranscrits > $prot.FPKMtranscrits.sort
#~ awk '{print$2}' $prot.FPKMtranscrits.sort > $prot.FPKMtranscrits.sort2
#~ sed 'y/,/./' $prot.FPKMtranscrits.sort2 > $prot.FPKMtranscrits.sort2point
#~ awk '{if ($1 > 2) print$0}' $prot.FPKMtranscrits.sort2point  > $prot.lesbonsventro
#~ sed 'y/./,/' $prot.lesbonsventro > $prot.lesbonsventrovirgule
#~ while IFS= read -r line 
#~ do
#~ grep $line $prot.FPKMtranscrits >> $prot.allventronom
#~ done < $prot.lesbonsventrovirgule
#~ done
#~ awk '{print$1}' $prot.allventronom|sort|uniq > $prot.lesbonsventros
#~ cat $prot.lesbonsventros > $prot.resultat.FPKM
#~ goodventral=$(cat $prot.lesbonsventros)
#~ for ventral in $goodventral
#~ do
#~ nomtaillealign=$(grep $ventral $prot.etape1bash| sort -nk3 | head -1 | awk '{print$1,$3}')
#~ grep -A1 $ventral Hf_int_All-Unigene.fq > $prot.$ventral.seq
#~ cat $prot.$ventral.seq >> $prot.FPKM.fasta.resultat
#~ taillealign=$(echo $nomtaillealign | awk '{print$2}')
#~ sixpack $prot.$ventral.seq -outfile $prot.$ventral.menfou -outseq $prot.$ventral.resultatsixpack 2>/dev/null
#~ awk '{print$12}' $prot.$ventral.resultatsixpack > $prot.$ventral.aalignes
#~ grep 'aa' $prot.$ventral.aalignes > $prot.$ventral.queaa
#~ sed -e ' s/aa//' $prot.$ventral.queaa > $prot.$ventral.que
#~ while IFS= read -r line
#~ do
#~ if (("$line" >= "$taillealign"))
#~ then
#~ echo "$line"' '"$ventral" >> $prot.$ventral.orfpossibleavectaille
#~ fi
#~ done < $prot.$ventral.que
#~ awk '{print$1}' $prot.$ventral.orfpossibleavectaille > $prot.$ventral.tailleorf
#~ sed 's/$/aa/' $prot.$ventral.tailleorf > $prot.$ventral.tailleorfaa
#~ /opt/seqtk/seqtk seq $prot.$ventral.resultatsixpack > $prot.$ventral.resultatsixpackfastq
#~ cat $prot.$ventral.tailleorfaa | sort -n | uniq -c > $prot.$ventral.tailleorfaacount
#~ awk '{print$1}' $prot.$ventral.tailleorfaacount > $prot.$ventral.tailleorfaacountrep
#~ awk -F\  '{print$2}' $prot.$ventral.tailleorfaacount > $prot.$ventral.tailleorfaacounttaille
#~ while IFS= read -r line
#~ do
#~ grep -A1 $line $prot.$ventral.resultatsixpackfastq > $prot.$ventral.$line.seqorf
#~ #A REVOIR cat $prot.$ventral.$line.seqorf >> $prot.resultat.$ventral.orf.fasta A REVOIR 
#~ #A REVOIR ~ cat $prot.resultat.$ventral.orf.fasta > $prot.resultat.allorf.fasta   A REVOIR 
#~ nmblignesorf=$(cat $prot.$ventral.$line.seqorf|wc -l)
#~ if
#~ (("$nmblignesorf" != "2" ))
#~ then
#~ awk 'NR>0 && NR<3' $prot.$ventral.$line.seqorf > $prot.$ventral.$line.seqorf.1
#~ hmmsearch --tblout $prot.$ventral.$line.domain.1 --cpu 16 /opt/pfam/Pfam-A.hmm $prot.$ventral.$line.seqorf.1
#~ sed '/^#/d' -i $prot.$ventral.$line.domain.1
#~ awk '{print$3}' $prot.$ventral.$line.domain.1 > $prot.$ventral.$line.domainsolo.1
#~ compteurdeligne1=$(wc -l $prot.$ventral.$line.domainsolo.1| awk '{print$1}')
#~ if
#~ (("$compteurdeligne1" != "0" ))
#~ then
#~ sort $prot.$ventral.$line.domainsolo.1 > $prot.$ventral.$line.domainsolo.sort.1 
#~ comm -12 resultat.$prot.domainsort $prot.$ventral.$line.domainsolo.sort.1 | awk 'BEGIN {FS=":|\t"} {print $1}' | awk '!/^$/' > resultat.$prot.$ventral.$line.domainencommun.1
#~ fi


#~ awk 'NR>3 && NR<6' $prot.$ventral.$line.seqorf > $prot.$ventral.$line.seqorf.2
#~ hmmsearch --tblout $prot.$ventral.$line.domain.2 --cpu 16 /opt/pfam/Pfam-A.hmm $prot.$ventral.$line.seqorf.2
#~ sed '/^#/d' -i $prot.$ventral.$line.domain.2
#~ awk '{print$3}' $prot.$ventral.$line.domain.2 > $prot.$ventral.$line.domainsolo.2
#~ compteurdeligne2=$(wc -l $prot.$ventral.$line.domainsolo.2| awk '{print$1}')
#~ if
#~ (("$compteurdeligne2" != "0" ))
#~ then
#~ sort $prot.$ventral.$line.domainsolo.2 > $prot.$ventral.$line.domainsolo.sort.2
#~ comm -12 resultat.$prot.domainsort $prot.$ventral.$line.domainsolo.sort.2 | awk 'BEGIN {FS=":|\t"} {print $1}' | awk '!/^$/' > resultat.$prot.$ventral.$line.domainencommun.2
#~ fi


#~ awk 'NR>6 && NR<9' $prot.$ventral.$line.seqorf > $prot.$ventral.$line.seqorf.3
#~ hmmsearch --tblout $prot.$ventral.$line.domain.3 --cpu 16 /opt/pfam/Pfam-A.hmm $prot.$ventral.$line.seqorf.3
#~ sed '/^#/d' -i $prot.$ventral.$line.domain.3
#~ awk '{print$3}' $prot.$ventral.$line.domain.3 > $prot.$ventral.$line.domainsolo.3
#~ compteurdeligne3=$(wc -l $prot.$ventral.$line.domainsolo.3| awk '{print$1}')
#~ if
#~ (("$compteurdeligne3" != "0" ))
#~ then
#~ sort $prot.$ventral.$line.domainsolo.3 > $prot.$ventral.$line.domainsolo.sort.3
#~ comm -12 resultat.$prot.domainsort $prot.$ventral.$line.domainsolo.sort.3 | awk 'BEGIN {FS=":|\t"} {print $1}' | awk '!/^$/' > resultat.$prot.$ventral.$line.domainencommun.3
#~ fi
#~ fi

#~ hmmsearch --tblout $prot.$ventral.$line.domain --cpu 16 /opt/pfam/Pfam-A.hmm $prot.$ventral.$line.seqorf

#~ sed '/^#/d' -i $prot.$ventral.$line.domain
#~ awk '{print$3}' $prot.$ventral.$line.domain > $prot.$ventral.$line.domainsolo

#~ compteurdeligne=$(wc -l $prot.$ventral.$line.domainsolo | awk '{print$1}')
#~ if
#~ (("$compteurdeligne" != "0" ))
#~ then
#~ sort $prot.$ventral.$line.domainsolo > $prot.$ventral.$line.domainsolo.sort 
#~ comm -12 resultat.$prot.domainsort $prot.$ventral.$line.domainsolo.sort > resultat.$prot.$ventral.$line.domainencommun
#~ fi


#~ if 
#~ test -s resultat.$prot.$ventral.$line.domainencommun
#~ then 
#~ echo "$prot" "$ventral" >> ensembledesprotetventralavecdomencomm
#~ fi
#~ if 
#~ test -s resultat.$prot.$ventral.$line.domainencommun.1
#~ then 
#~ echo "$prot" "$ventral" >> ensembledesprotetventralavecdomencomm
#~ fi
#~ if 
#~ test -s resultat.$prot.$ventral.$line.domainencommun.2
#~ then 
#~ echo "$prot" "$ventral" >> ensembledesprotetventralavecdomencomm
#~ fi
#~ if 
#~ test -s resultat.$prot.$ventral.$line.domainencommun.3
#~ then 
#~ echo "$prot" "$ventral" >> ensembledesprotetventralavecdomencomm
#~ fi

#~ done < $prot.$ventral.tailleorfaacounttaille


#~ done
#~ done


#~ RESULTATTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT

nmbrprotbanque=$(grep '>' All_Sfp.txt |wc -l)
echo " Il y a $nmbrprotbanque protéines dans la banque" >> resultatglobal

nmbprot=$(awk '{print$1}' allprot.blast | sort | uniq |wc -l)
echo "Nombre de protéines avec au moins 1 alignement : $nmbprot" >> resultatglobal

nmbrdiffprot=$(($nmbrprotbanque-$nmbprot))
echo " Il y a donc $nmbrdiffprot prtoéines qui ne sont pas alignées :
" >>resultatglobal

nomprotalign=$(awk '{print$1}' allprot.blast|sort|uniq)
awk '{print$1}' allprot.blast|sort|uniq > protalign
nomprotbanque=$(grep '>' All_Sfp.txt | cut -d '>' -f 2)
grep '>' All_Sfp.txt| cut -d '>' -f 2 > protbank
nomdiffprot=$(diff -y protbank protalign | grep '<' | cut -d '<' -f1)
echo "$nomdiffprot" >>resultatglobal


echo "Noms des protéines allignées :
$nomprotalign"  >> resultatglobal


for prot in $nomprotalign
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

nmbrtrandom=$(grep -w "$prot" ensembledesprotetventralavecdomencomm |awk '{print$2}'|sort|uniq|wc -l)
echo " Sur les $nmbrtran transcrits gardés, il y a $nmbrtrandom avec au moins 1 domaine en commun " >> resultatglobal

nomtrandom=$(grep -w "$prot" ensembledesprotetventralavecdomencomm |awk '{print$2}'|sort |uniq)

for traneval in $nomtrandom 
do
grep -w "$prot" allprot.blast|grep -w "$traneval"  | awk '{print$1,$2,$3}'|sort -gk2|head -1 >>fichiertempotranseteval
done
transeteval=$(grep -w "$prot" fichiertempotranseteval| awk '{print$2,$3}' | sort -gk2)
echo " 
Voici la liste de ces transcrits classés par ordre d'evalue : 
$transeteval" >> resultatglobal


done 

#~ NETOYAGEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
#~ rm protalign
#~ rm protbank
