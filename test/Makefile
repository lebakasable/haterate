.PHONY: all
all: bubblesort bubblesort.pdf btree.py

bubblesort: bubblesort.c
	cc -Wall -Wextra -std=c11 -pedantic -ggdb -c bubblesort.c

bubblesort.c: bubblesort.tex
	./haterate bubblesort.tex > bubblesort.c

bubblesort.pdf: bubblesort.tex
	pdflatex bubblesort.tex

btree.py: btree.md
	@python btree.py

.PHONY: btree.md
btree.md: btree.md
	./haterate -m md -l python btree.md > btree.py

