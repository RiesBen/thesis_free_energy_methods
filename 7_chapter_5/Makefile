bib_sources=content.tex
bib_sources+=inc/intro.tex
bib_sources+=inc/methods.tex
bib_sources+=inc/theory.tex
bib_sources+=inc/results.tex
bib_sources+=inc/conclusion.tex
bib_sources+=inc/appendix.tex
lars=../lars_to_bib
all:
	mkdir -p ref
	cat $(bib_sources) > ./ref/all.tex
	cp ~/lars/lars.txt ./ref/	
	echo 'y' | $(lars) -f mol_simul_title -c no -s yes ./ref/lars.txt ./ref/all.tex ./inc/paper.lrs 
#	cat paper.lrs | sed '\
s/pp. XXX-XXX./in press./g;\
s/ Available at: {\\em }//g\
0,/^% SUP_MAT reference not found.*$/s/^% SUP_MAT reference not found.*$/\\bibitem{SUP_MAT} Supporting Information document/g; \
' > tmplrs
#	mv tmplrs paper.lrs
	pdflatex  --shell-escape content
	# egrep '^\!' content.log > err.log
	# if [ `cat err.log | wc -l` != 0 ]; then
	#   echo COMPILATION ERRORS
	#   cat err.log  
	#   echo look in paper.log for more details...
	#   exit
	# endif
	# rm err.log >& /dev/null
	pdflatex content
