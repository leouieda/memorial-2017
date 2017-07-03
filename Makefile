# This is a simple Makefile for compiling LaTeX documents.
# You'll find the original at https://github.com/pinga-lab/latex_makefile

# Based on the work of
# Joshua Ryan Smith (https://github.com/jrsmith3/latex_template)
# and
# Jason Hiebel (https://github.com/JasonHiebel/latex.makefile)

# CONFIGURATION
###############################################################################

# The name of the main .tex file to build.
# Other files can be included into this one.
PROJECT = memorial-2017
# Folder where the figure files are (will assume they are EPS format)
FIGDIR = figures

### File Types (for dependencies)
TEX = $(wildcard *.tex)
BIB = $(wildcard *.bib)
STY = $(wildcard *.sty)
CLS = $(wildcard *.cls)
BST = $(wildcard *.bst)
EPS = $(wildcard $(FIGDIR)/*.eps)

### Compilation Flags
LATEX_FLAGS  = -halt-on-error

### Standard PDF Viewers
UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
PDFVIEWER = okular
endif
ifeq ($(UNAME), Darwin)
PDFVIEWER = open
endif


all: $(PROJECT).pdf

lowres: $(PROJECT)-lowres.pdf

%-lowres.pdf: %.pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$@ $<

%.pdf: %.tex $(STY) $(CLS) $(BIB) $(BST) $(EPS) $(TEX)
	pdflatex $(LATEX_FLAGS) $< 1>/dev/null
	bibtex $(patsubst %.tex,%,$<)
	pdflatex $(LATEX_FLAGS) $< 1>/dev/null
	pdflatex $(LATEX_FLAGS) $<

show: all
	@ # Redirect stdout and stderr to /dev/null for silent execution
	@ (${PDFVIEWER} $(PROJECT).pdf > /dev/null 2>&1 & )

wc: all
	@ pdftotext $(PROJECT).pdf - | wc -w

### Clean
# This target cleans the temporary files generated by the tex programs
clean:
	rm -rf *.aux *.log *.bbl *.blg *.out
	rm -rf $(PROJECT).pdf
	rm -rf $(FIGDIR)/*-eps-converted-to.pdf
