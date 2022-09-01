##
# Project Title
#
# @file
# @version 0.1

all: main.pdf

-include latex.out/deps/*.d

latex.out/svg/%.pdf: kitchen/inkscape-export.py
	@mkdir -p latex.out/deps
	./kitchen/inkscape-export.py --output-directory "$(dir $@)" "$(patsubst latex.out/svg/%/,res/%,$(dir $@))" > "$(patsubst latex.out/svg/%/,latex.out/deps/%.d,$(dir $@))"

latex.out/main.pdf: main.tex
	@mkdir -p latex.out/deps
	latexmk -use-make -deps -deps-out=latex.out/deps/main.d -pdfxe --synctex=1 -output-directory=latex.out -interaction=nonstopmode -file-line-error main.tex | sed -re '0,/CONTENT START NOW/d'
	pplatex -q -i latex.out/main.log
	@grep -v "INFO - " latex.out/main.blg || true

main.pdf: latex.out/main.pdf
	cp latex.out/main.pdf .
	cp latex.out/main.synctex.gz .

.PHONY: clean
clean:
	rm -rf latex.out

# end
