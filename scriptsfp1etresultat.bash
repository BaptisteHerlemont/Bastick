#~ #! /bin/bash
cp /home/baptiste/bOMBSTAGE2022/sequences/sfp1 .
cp /home/baptiste/bOMBSTAGE2022/sequences/Hf_int_All-Unigene.fa .
/opt/blast/ncbi-blast-2.12.0+/bin/makeblastdb -in Hf_int_All-Unigene.fa -dbtype nucl
/opt/blast/ncbi-blast-2.12.0+/bin/makeblastdb -in sfp1 -dbtype prot
/opt/blast/ncbi-blast-2.12.0+/bin/tblastn -query sfp1 -db Hf_int_All-Unigene.fa -evalue 1e-10 -outfmt "6 delim= sseqid evalue length" -out sfp1bash.blast
cat sfp1bash.blast | sort -k1 > etape1bash
/opt/seqtk/seqtk seq Hf_int_All-Unigene.fa > Hf_int_All-Unigene.fq
hmmsearch --tblout sfp1.domain --cpu 16 /opt/pfam/Pfam-A.hmm sfp1
sed '/^#/d' -i sfp1.domain
awk '{print$3}' sfp1.domain > resultat.sfp1.domain
sort resultat.sfp1.domain > resultat.sfp1.domainsort
nomtranscrits=$(awk '{print$1}' etape1bash |uniq)
echo "$nomtranscrits" > resultat.blast
for transcrits in $nomtranscrits
do
grep -A1 $transcrits Hf_int_All-Unigene.fq >> blast.fasta.resultat
sed 's/;/ /g' /home/baptiste/bOMBSTAGE2022/FPKM/Copie_de_Supplementary_Table_S2_Global_Annotation.csv > Copieespace.csv
awk '{print$1,$7}' Copieespace.csv > Copie2col.csv
grep $transcrits Copie2col.csv >> FPKMtranscrits
sort -nk2 FPKMtranscrits > FPKMtranscrits.sort
awk '{print$2}' FPKMtranscrits.sort > FPKMtranscrits.sort2
sed 'y/,/./' FPKMtranscrits.sort2 > FPKMtranscrits.sort2point
awk '{if ($1 > 2) print$0}' FPKMtranscrits.sort2point  > lesbonsventro
sed 'y/./,/' lesbonsventro > lesbonsventrovirgule
while IFS= read -r line 
do
grep $line FPKMtranscrits >> allventronom
done < lesbonsventrovirgule
done
awk '{print$1}' allventronom|sort|uniq > lesbonsventros
cat lesbonsventros > resultat.FPKM
goodventral=$(cat lesbonsventros)
for ventral in $goodventral
do
nomtaillealign=$(grep $ventral etape1bash| sort -nk3 | head -1 | awk '{print$1,$3}')
grep -A1 $ventral Hf_int_All-Unigene.fq > $ventral.seq
cat $ventral.seq >> FPKM.fasta.resultat
taillealign=$(echo $nomtaillealign | awk '{print$2}')
sixpack $ventral.seq -outfile $ventral.menfou -outseq $ventral.resultatsixpack 2>/dev/null
awk '{print$12}' $ventral.resultatsixpack > $ventral.aalignes
grep 'aa' $ventral.aalignes > $ventral.queaa
sed -e ' s/aa//' $ventral.queaa > $ventral.que
while IFS= read -r line
do
if (("$line" >= "$taillealign"))
then
echo "$line"' '"$ventral" >> $ventral.orfpossibleavectaille
fi
done < $ventral.que
awk '{print$1}' $ventral.orfpossibleavectaille > $ventral.tailleorf
sed 's/$/aa/' $ventral.tailleorf >$ventral.tailleorfaa
/opt/seqtk/seqtk seq $ventral.resultatsixpack > $ventral.resultatsixpackfastq
cat $ventral.tailleorfaa | sort -n | uniq -c > $ventral.tailleorfaacount
awk '{print$1}' $ventral.tailleorfaacount > $ventral.tailleorfaacountrep
awk -F\  '{print$2}' $ventral.tailleorfaacount > $ventral.tailleorfaacounttaille
while IFS= read -r line
do
grep -A1 $line $ventral.resultatsixpackfastq > $ventral.$line.seqorf
cat $ventral.$line.seqorf >> resultat.$ventral.orf.fasta
cat resultat.$ventral.orf.fasta > resultat.allorf.fasta
nmblignesorf=$(cat $ventral.$line.seqorf|wc -l)
if
(("$nmblignesorf" != "2" ))
then
awk 'NR>0 && NR<3' $ventral.$line.seqorf > $ventral.$line.seqorf.1
hmmsearch --tblout $ventral.$line.domain.1 --cpu 16 /opt/pfam/Pfam-A.hmm $ventral.$line.seqorf.1
sed '/^#/d' -i $ventral.$line.domain.1
awk '{print$3}' $ventral.$line.domain.1 > $ventral.$line.domainsolo.1
compteurdeligne1=$(wc -l $ventral.$line.domainsolo.1| awk '{print$1}')
if
(("$compteurdeligne1" != "0" ))
then
sort $ventral.$line.domainsolo.1 > $ventral.$line.domainsolo.sort.1 
comm -12 resultat.sfp1.domainsort $ventral.$line.domainsolo.sort.1 | awk 'BEGIN {FS=":|\t"} {print $1}' | awk '!/^$/' > resultat.$ventral.$line.domainencommun.1
fi
awk 'NR>3 && NR<6' $ventral.$line.seqorf > $ventral.$line.seqorf.2
hmmsearch --tblout $ventral.$line.domain.2 --cpu 16 /opt/pfam/Pfam-A.hmm $ventral.$line.seqorf.2
sed '/^#/d' -i $ventral.$line.domain.2
awk '{print$3}' $ventral.$line.domain.2 > $ventral.$line.domainsolo.2
compteurdeligne2=$(wc -l $ventral.$line.domainsolo.2| awk '{print$1}')
if
(("$compteurdeligne2" != "0" ))
then
sort $ventral.$line.domainsolo.2 > $ventral.$line.domainsolo.sort.2
comm -12 resultat.sfp1.domainsort $ventral.$line.domainsolo.sort.2 | awk 'BEGIN {FS=":|\t"} {print $1}' | awk '!/^$/' > resultat.$ventral.$line.domainencommun.2
fi
fi

hmmsearch --tblout $ventral.$line.domain --cpu 16 /opt/pfam/Pfam-A.hmm $ventral.$line.seqorf

sed '/^#/d' -i $ventral.$line.domain
awk '{print$3}' $ventral.$line.domain > $ventral.$line.domainsolo

compteurdeligne=$(wc -l $ventral.$line.domainsolo | awk '{print$1}')
if
(("$compteurdeligne" != "0" ))
then
sort $ventral.$line.domainsolo > $ventral.$line.domainsolo.sort 
comm -12 resultat.sfp1.domainsort $ventral.$line.domainsolo.sort > resultat.$ventral.$line.domainencommun
fi

done < $ventral.tailleorfaacounttaille
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

#~ cp /home/baptiste/bOMBSTAGE2022/sequences/adhesive_protein .
#~ /opt/blast/ncbi-blast-2.12.0+/bin/makeblastdb -in adhesive_protein -dbtype prot
#~ cp /home/baptiste/bOMBSTAGE2022/sequences/Hf_int_All-Unigene.fa .
#~ /opt/blast/ncbi-blast-2.12.0+/bin/makeblastdb -in Hf_int_All-Unigene.fa -dbtype nucl
#~ /opt/blast/ncbi-blast-2.12.0+/bin/tblastn -query adhesive_protein -db Hf_int_All-Unigene.fa -evalue 1e-10 -outfmt "6 delim= qseqid sseqid evalue length" -out allprot.blast
listedeprot=$(awk '{print$1}' allprot.blast |sort|uniq)
for prot in $listedeprot
do
grep -A1 $prot adhesive_protein > $prot.fasta
done
