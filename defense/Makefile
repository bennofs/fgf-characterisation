##
# Project Title
#
# @file
# @version 0.1
ENGINE ?= xelatex

all: van-benthem-fgf-slides.pdf van-benthem-fgf-slides.synctex.gz

-include latex.out/deps/*.d

latex.out/van-benthem-fgf-slides-${ENGINE}.pdf: van-benthem-fgf-slides.tex tolcolors.tex
	@mkdir -p latex.out/deps
	( latexmk -MP -deps -deps-out=latex.out/deps/van-benthem-fgf-slides.d -jobname=van-benthem-fgf-slides-${ENGINE} -${ENGINE} --synctex=1 -output-directory=latex.out -interaction=nonstopmode -no-file-line-error van-benthem-fgf-slides.tex || echo -e '\033[0;31mDocument has errors\033[0m' ) | sed -re '0,/CONTENT START NOW/d'
	pplatex -q -i latex.out/van-benthem-fgf-slides-${ENGINE}.log
	@grep -qv "INFO - " latex.out/van-benthem-fgf-slides-${ENGINE}.blg || true

latex.out/sandbox-${ENGINE}.pdf: sandbox.tex tolcolors.tex
	@mkdir -p latex.out/deps
	( latexmk -MP -use-make -deps -deps-out=latex.out/deps/sanbdox.d -jobname=sandbox-${ENGINE} -${ENGINE} --synctex=1 -output-directory=latex.out -interaction=nonstopmode -no-file-line-error sandbox.tex || echo -e '\033[0;31mDocument has errors\033[0m' )
	pplatex -q -i latex.out/sandbox-${ENGINE}.log
	@grep -qv "INFO - " latex.out/sandbox-${ENGINE}.blg || true

van-benthem-fgf-slides.pdf van-benthem-fgf-slides.synctex.gz: latex.out/van-benthem-fgf-slides-${ENGINE}.pdf
	cp latex.out/van-benthem-fgf-slides-${ENGINE}.pdf van-benthem-fgf-slides.pdf
	cp latex.out/van-benthem-fgf-slides-${ENGINE}.synctex.gz van-benthem-fgf-slides.synctex.gz

sandbox.pdf: latex.out/sandbox-${ENGINE}.pdf
	cp latex.out/sandbox-${ENGINE}.pdf sandbox.pdf

.PHONY: release
release: van-benthem-fgf-slides.pdf
	mkdir -p out
	cp van-benthem-fgf-slides.pdf out/van-benthem-fgf-slides-$$(git rev-list --count HEAD).pdf

.PHONY: clean
clean:
	rm -rf latex.out

# end
