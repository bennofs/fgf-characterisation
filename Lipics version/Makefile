##
# Project Title
#
# @file
# @version 0.1
ENGINE ?= pdflatex

all: main.pdf main.synctex.gz

-include latex.out/deps/*.d

latex.out/main-${ENGINE}.pdf: main.tex
	@mkdir -p latex.out/deps
	( latexmk -MP -deps -deps-out=latex.out/deps/main.d -jobname=main-${ENGINE} -${ENGINE} --synctex=1 -output-directory=latex.out -interaction=nonstopmode -no-file-line-error main.tex || echo -e '\033[0;31mDocument has errors\033[0m' )
	pplatex -q -i latex.out/main-${ENGINE}.log
	@grep -qv "INFO - " latex.out/main-${ENGINE}.blg || true

main.pdf main.synctex.gz: latex.out/main-${ENGINE}.pdf
	cp latex.out/main-${ENGINE}.pdf main.pdf
	cp latex.out/main-${ENGINE}.synctex.gz main.synctex.gz

.PHONY: clean
clean:
	rm -rf latex.out

# end
