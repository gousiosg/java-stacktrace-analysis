FILE=android-stacks

default: $(FILE).pdf

$(FILE).pdf: $(FILE).tex $(FILE).bib
	pdflatex $(FILE)
	bibtex $(FILE)
	pdflatex $(FILE)
	pdflatex $(FILE)

clean:
	-rm *.cb *.cb2 *.bbl *.blg *.brf *.lof *.lol *.lot *.out *.toc *.log *.aux  
	-rm *~
	-rm $(FILE).pdf
