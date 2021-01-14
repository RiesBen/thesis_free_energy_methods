#! /bin/bash

echo "./frontback/acknowledgements.tex ./frontback/abstract.tex ./frontback/publications.tex" > sources.dat
for i in intro `seq 1 4` outlook; do 
    printf "%s " "chapter_${i}/content.tex"; 
    cat chapter_${i}/content.tex | grep input |  awk -F "[{} /]" -v path=chapter_${i} '{for (i=1; i <= NF; i+=1 ) {if ( $i ~ ".tex") {printf "%s ", path"/"$(i-1)"/"$i;};};}'; 
done >> ./sources.dat
echo "./frontback/cv.tex" >> sources.dat
cat $( cat ./sources.dat )
