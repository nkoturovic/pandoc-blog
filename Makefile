POST=$(shell find blog-src/post/*)
# OUT contains all names of static HTML targets corresponding to markdown files
# in the post directory.
OUT=$(patsubst blog-src/post/%.md, blog-out/post/%.html, $(POST))

all: pre $(OUT) index.html
	
pre: 
	mkdir -p blog-out
	mkdir -p blog-out/post
	mkdir -p blog-out/pdf
	cp styles blog-out/ -r
	cp blog-src/img blog-out/img -r


blog-out/post/%.html: blog-src/post/%.md
	pandoc -s --highlight-style=pygments -f markdown+fenced_divs -s $< -o $@ \
	       --template templates/post.html --filter ./filters/pretty-date.py --css="../styles/common.css" --css="../styles/post.css" \
		   -M filename="$(shell echo "$@" | sed -E 's:.*/(.*)\.html:\1:')"
		   # --toc --toc-depth=3 
	pandoc $< --template templates/post.latex --listings --pdf-engine=xelatex --resource-path="./blog-out/img" \
		   --filter ./filters/pretty-date.py \
		   -o "./blog-out/pdf/$(shell echo "$@" | sed -E 's:.*/(.*)\.html:\1:').pdf" \
	       -V colorlinks -M monofont=Inconsolata 

index.html: $(OUT) make_index.py
	python3 make_index.py
	pandoc -s blog-out/index.md -o blog-out/index.html --template templates/index.html \
	   	   --css="./styles/common.css" --css="./styles/index.css" -M title="Blog"
	rm blog-out/index.md

# Shortcuts

open: all
	open index.html

# Get an ISO 8601 date.
date:
	date -u +"%Y-%m-%dT%H:%M:%SZ"

clean:
	rm -r blog-out

hook:
	ln -s -f ../../.hooks/pre-commit ./.git/hooks/pre-commit

.PHONY: install
install:
	pip install -r requirements.txt
