# Makefile for the 3288shortcutsmanager slideshow LaTeX build
# Reproduces the manual sequence:
#   lualatex main
#   open -a Skim.app main.pdf
#
# Targets:
#   make            build frontiers.pdf (four passes with BibTeX)
#   make view       build, then open the PDF in Skim
#   make clean      remove LaTeX auxiliary files
#   make cleanall   remove auxiliary files and the PDF
#   make help       list these targets

DOC    = main
LATEX  = lualatex
LFLAGS = -interaction=nonstopmode -synctex=1
# BIBTEX = bibtex
VIEWER = open -a Skim.app

.PHONY: all view open clean cleanall help

all: $(DOC).pdf

# First pass writes the .aux, BibTeX reads it, and the two further passes
# resolve citations and cross-references. The leading "-" tells make to keep
# going if a pass returns a nonzero exit, so the build always finishes and
# opens the PDF instead of halting (the tolerant equivalent of typing S at the
# error prompt). Once the bibliography compiles cleanly you can drop the
# dashes to have make stop on any real error.
$(DOC).pdf: $(DOC).tex
	-$(LATEX) $(LFLAGS) $(DOC)
	 -$(LATEX) $(LFLAGS) $(DOC)
# -$(BIBTEX) $(DOC)
# -$(LATEX) $(LFLAGS) $(DOC)


# Build, then open in Skim. Skim reloads the file automatically when it is
# already open, so this is safe to rerun.
view open: $(DOC).pdf
	$(VIEWER) $(DOC).pdf

clean:
	rm -f $(DOC).aux $(DOC).bbl $(DOC).blg $(DOC).log $(DOC).out \
	      $(DOC).toc $(DOC).lof $(DOC).lot $(DOC).synctex.gz \
	      $(DOC).fls $(DOC).fdb_latexmk $(DOC).brf *-eps-converted-to.pdf

cleanall: clean
	rm -f $(DOC).pdf

help:
	@echo "make          build $(DOC).pdf (pdflatex, bibtex, pdflatex x2)"
	@echo "make view     build, then open $(DOC).pdf in Skim"
	@echo "make clean    remove LaTeX auxiliary files"
	@echo "make cleanall remove auxiliary files and $(DOC).pdf"
