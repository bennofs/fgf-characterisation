##
# Project Title
#
# @file
# @version 0.1
ENGINE ?= pdflatex

all: main.pdf main.synctex.gz

-include latex.out/deps/*.d

latex.out/svg/%.pdf:
	@mkdir -p latex.out/deps
	./kitchen/inkscape-export.py --output-directory "$(dir $@)" "$(patsubst latex.out/svg/%/,res/%,$(dir $@))" > "$(patsubst latex.out/svg/%/,latex.out/deps/%.d,$(dir $@))"

latex.out/main-${ENGINE}.pdf: main.tex tolcolors.tex
	@mkdir -p latex.out/deps
	( latexmk -MP -use-make -deps -deps-out=latex.out/deps/main.d -jobname=main-${ENGINE} -${ENGINE} --synctex=1 -output-directory=latex.out -interaction=nonstopmode -no-file-line-error main.tex || echo -e '\033[0;31mDocument has errors\033[0m' ) | sed -re '0,/CONTENT START NOW/d'
	pplatex -q -i latex.out/main-${ENGINE}.log
	@grep -qv "INFO - " latex.out/main-${ENGINE}.blg || true

main.pdf main.synctex.gz: latex.out/main-${ENGINE}.pdf
	cp latex.out/main-${ENGINE}.pdf main.pdf
	cp latex.out/main-${ENGINE}.synctex.gz main.synctex.gz

.PHONY: clean
clean:
	rm -rf latex.out

# end
