.IGNORE:	all lit spell

lars_dir=/home/dahahn/lars
lars=./lars_to_bib

#bib_sources += chapter_1/content.tex
#bib_sources += chapter_2/content.tex
#bib_sources += chapter_3/content.tex
#bib_sources+=chapter_4/content.tex
#bib_sources+=chapter_4/inc/intro.tex
#bib_sources += chapter_5/content.tex
#bib_sources += chapter_outlook/content.tex


#all:
#	pdflatex test_title.tex
#	pdflatex test_title.tex

all:
	lualatex  --shell-escape main.tex &> /dev/null
	egrep '^\!' main.log
	lualatex main.tex &> /dev/null

ch1:
	${MAKE} -c ./chapter_1/
ch2:
	${MAKE} -c ./chapter_2/
ch3:
	${MAKE} -c ./chapter_3/
ch4:
	${MAKE} -c ./chapter_4/
lit:
	./make_bib_sources.sh  > all.tex
	yes | $(lars) -f j_comput_chem_title -c no $(lars_dir)/lars.txt all.tex frontback/lars.bib
	cat frontback/lars.bib | sed 's/pp. XXX-XXX./in press./g;s/ Available at: {\\em }//g;s/ pp https/https/g;' > tmplrs
	mv tmplrs frontback/lars.bib
	rm all.tex

spell:
	./make_bib_sources.sh  > all.tex
	cat all.tex | aspell -t list  | sort | uniq > spell_check.dat
	rm all.tex
