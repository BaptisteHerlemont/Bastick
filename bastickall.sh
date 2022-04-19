#! /bin/bash
sed 's/;/ /g' /home/baptiste/bOMBSTAGE2022/FPKM/Copie_de_Supplementary_Table_S2_Global_Annotation.csv > Copieespace.csv
awk '{print$1,$7}' Copieespace.csv > Copie2col.csv
cp /home/baptiste/bOMBSTAGE2022/sequences/Hf_int_All-Unigene.fa .
/opt/blast/ncbi-blast-2.12.0+/bin/makeblastdb -in Hf_int_All-Unigene.fa -dbtype nucl
/opt/seqtk/seqtk seq Hf_int_All-Unigene.fa > Hf_int_All-Unigene.fq
cp /home/baptiste/bOMBSTAGE2022/sequences/adhesive_protein .
/opt/blast/ncbi-blast-2.12.0+/bin/makeblastdb -in adhesive_protein -dbtype prot
/opt/blast/ncbi-blast-2.12.0+/bin/tblastn -query adhesive_protein -db Hf_int_All-Unigene.fa -evalue 1e-10 -outfmt "6 delim= qseqid sseqid evalue length" -out allprot.blast
#~ listedeprot=$(awk '{print$1}' allprot.blast |sort|uniq)
#~ for prot in $listedeprot
#~ do
grep -A1 $prot adhesive_protein > $prot.fasta
/opt/blast/ncbi-blast-2.12.0+/bin/makeblastdb -in $prot.fasta -dbtype prot

/opt/blast/ncbi-blast-2.12.0+/bin/tblastn -query $prot.fasta -db Hf_int_All-Unigene.fa -evalue 1e-10 -outfmt "6 delim= sseqid evalue length" -out $prot.blast
cat $prot.blast | sort -k1 > $prot.etape1bash
hmmsearch --tblout $prot.domain --cpu 16 /opt/pfam/Pfam-A.hmm $prot.fasta
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
awk '{if ($1 > 2) print$0}' $prot.FPKMtranscrits.sort2point  > $prot.lesbonsventro
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
/opt/seqtk/seqtk seq $prot.$ventral.resultatsixpack > $prot.$ventral.resultatsixpackfastq
cat $prot.$ventral.tailleorfaa | sort -n | uniq -c > $prot.$ventral.tailleorfaacount
awk '{print$1}' $prot.$ventral.tailleorfaacount > $prot.$ventral.tailleorfaacountrep
awk -F\  '{print$2}' $prot.$ventral.tailleorfaacount > $prot.$ventral.tailleorfaacounttaille
while IFS= read -r line
do
grep -A1 $line $prot.$ventral.resultatsixpackfastq > $prot.$ventral.$line.seqorf
#~ A REVOIR cat $prot.$ventral.$line.seqorf >> $prot.resultat.$ventral.orf.fasta A REVOIR 
#A REVOIR ~ cat $prot.resultat.$ventral.orf.fasta > $prot.resultat.allorf.fasta   A REVOIR 
nmblignesorf=$(cat $prot.$ventral.$line.seqorf|wc -l)
if
(("$nmblignesorf" != "2" ))
then
awk 'NR>0 && NR<3' $prot.$ventral.$line.seqorf > $prot.$ventral.$line.seqorf.1
hmmsearch --tblout $prot.$ventral.$line.domain.1 --cpu 16 /opt/pfam/Pfam-A.hmm $prot.$ventral.$line.seqorf.1
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
hmmsearch --tblout $prot.$ventral.$line.domain.2 --cpu 16 /opt/pfam/Pfam-A.hmm $prot.$ventral.$line.seqorf.2
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
hmmsearch --tblout $prot.$ventral.$line.domain.3 --cpu 16 /opt/pfam/Pfam-A.hmm $prot.$ventral.$line.seqorf.3
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

hmmsearch --tblout $prot.$ventral.$line.domain --cpu 16 /opt/pfam/Pfam-A.hmm $prot.$ventral.$line.seqorf

sed '/^#/d' -i $prot.$ventral.$line.domain
awk '{print$3}' $prot.$ventral.$line.domain > $prot.$ventral.$line.domainsolo

compteurdeligne=$(wc -l $prot.$ventral.$line.domainsolo | awk '{print$1}')
if
(("$compteurdeligne" != "0" ))
then
sort $prot.$ventral.$line.domainsolo > $prot.$ventral.$line.domainsolo.sort 
comm -12 resultat.$prot.domainsort $prot.$ventral.$line.domainsolo.sort > resultat.$prot.$ventral.$line.domainencommun
fi

done < $prot.$ventral.tailleorfaacounttaille
done
done
#~ mkdir sfp1resultat
#~ cp resultat.blast /sfp1resultat
#~ cp blast.fasta.resultat /sfp1resultat
#~ cp resultat.FPKM /sfp1resultat
#~ cp FPKM.fasta.resultat /sfp1resultat
#~ cp *.domainencommun* /sfp1resultat
#~ rm etape1bash
#~ rm *.domain.*
#~ rm *.domainsolo*
#~ rm *.domainsolo.sort
#~ rm *.seqorf*
#~ rm *.orfpossibleavectaille
#~ rm *.que
#~ rm *.queaa
#~ rm *.resultatsixpackfastq
#~ rm *.tailleorf
#~ rm *.tailleorfaa
#~ rm *.tailleorfaacount
#~ rm *.tailleorfaacountrep
#~ rm *.tailleorfaacounttaille
#~ rm *.menfou
#~ rm *.aalignes
#~ rm *.resultatsixpack
#~ rm *.seq
#~ rm *.fasta
#~ rm *.sort*
#~ rm allventronom
#~ rm lesbonsventro
#~ rm lesbonsventrovirgule
#~ rm lesbonsventros
#~ rm FPKMtranscrits*
#~ rm C*
#~ rm Hf_int_All-Unigene.f*
#~ rm sfp1*

