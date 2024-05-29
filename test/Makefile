.PHONY: all
all: bubblesort bubblesort.pdf btree.py

bubblesort: bubblesort.c
	cc -Wall -Wextra -std=c11 -pedantic -ggdb -c bubblesort.c

bubblesort.c: bubblesort.tex
	./haterate -o bubblesort.c bubblesort.tex

bubblesort.pdf: bubblesort.tex
	pdflatex bubblesort.tex

btree.py: btree.md
	@python btree.py

btree.md:
	./haterate -m md -l python -o btree.py btree.md

