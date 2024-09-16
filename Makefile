# https://unix.stackexchange.com/questions/274428/how-do-i-reduce-the-size-of-a-pdf-file-that-contains-images
# https://medium.com/@minamimunakata/how-to-store-images-for-use-in-readme-md-on-github-9fb54256e951
#--pdf-engine=xelatex  --embed-resources --standalone --dpi=150
#_$(CURRENT_DATE)

BUILDDIR := ./build

CURRENT_DATE := $(shell date +%Y-%m-%d)

#SHARED_OPTIONS := -f markdown -f markdown-tex_math_dollars --embed-resources --standalone --shift-heading-level-by=-1 --filter pandoc-include -V date=$(CURRENT_DATE) ./main.md

SHARED_OPTIONS := -f markdown -f markdown-tex_math_dollars --shift-heading-level-by=-1 --filter pandoc-include -V date=$(CURRENT_DATE) ./main.md

build_dir:
	mkdir -p $(BUILDDIR)

build_images_dir:
	mkdir -p $(BUILDDIR)/images

./$(BUILDDIR)/images/%: ./images/%
	magick $< -resize '1000x>' $@

html_images: build_images_dir $(patsubst ./images/%, $(BUILDDIR)/images/%, $(wildcard ./images/*))

./$(BUILDDIR)/dos_bench_embed.md:
	./utils/conv_csv.sh

html: build_dir html_images ./$(BUILDDIR)/dos_bench_embed.md
	pandoc -t html5 --highlight-style pygments -o $(BUILDDIR)/The_Ultimate_486_Upgrade.html $(SHARED_OPTIONS)

pdf: build_dir ./$(BUILDDIR)/dos_bench_embed.md
	pandoc -f markdown-implicit_figures -t pdf --pdf-engine=xelatex --highlight-style pygments -o $(BUILDDIR)/tmp.pdf $(SHARED_OPTIONS)
	gs -sDEVICE=pdfwrite -dPDFSETTINGS=/screen -q -o $(BUILDDIR)/The_Ultimate_486_Upgrade.pdf $(BUILDDIR)/tmp.pdf
	rm $(BUILDDIR)/tmp.pdf

all: html pdf

.PHONY: build_dir html html_images pdf all build_images_dir
.DEFAULT_GOAL := all
