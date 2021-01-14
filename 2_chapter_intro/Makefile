.IGNORE:	all
bib_sources=content.tex
lars=../lars_to_bib
all:
	mkdir -p ref
	cat $(bib_sources) > ./ref/all.tex
	cp ~/lars/lars.txt ./ref/	
	echo 'y' | $(lars) -f mol_simul_title -c no -s yes ./ref/lars.txt ./ref/all.tex ./inc/paper.lrs &> /dev/null
	lualatex  content.tex &> /dev/null
	egrep '^\!' content.log
	lualatex content.tex &> /dev/null


clean:
	rm -f err.log content.log content.aux content.auxlock

