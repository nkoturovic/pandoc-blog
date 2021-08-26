POST=$(shell find src/post/*)
# OUT contains all names of static HTML targets corresponding to markdown files
# in the post directory.
OUT=$(patsubst src/post/%.md, out/post/%.html, $(POST))

all: pre out/styles $(OUT) out/index.html out/blog.html favicon
	
pre: 
	mkdir -p src/post
	mkdir -p src/files
	mkdir -p src/img
	mkdir -p src/font
	mkdir -p out
	mkdir -p out/post
	mkdir -p out/pdf
	mkdir -p out/files
	mkdir -p out/img
	mkdir -p out/font
	cp src/img/* out/img -r
	cp src/font/* out/font -r
	cp src/files/* out/files -r

favicon: src/img/favicon/android-chrome-192x192.png src/img/favicon/android-chrome-512x512.png src/img/favicon/apple-touch-icon.png src/img/favicon/favicon-16x16.png src/img/favicon/favicon-32x32.png src/img/favicon/favicon.ico src/img/favicon/site.webmanifest
	cp $^ out/

out/index.html: templates/index.html
	cp templates/index.html out/index.html

out/styles: styles/common.css styles/blog.css styles/post.css styles/nav.css styles/index.css
	cp styles out/ -r

out/post/%.html: src/post/%.md
	pandoc -s --highlight-style=pygments -f markdown+fenced_divs -s $< -o $@ \
	       --template templates/post.html --filter ./filters/pretty-date.py --css="../styles/common.css" --css="../styles/post.css" \
		   -M filename="$(shell echo "$@" | sed -E 's:.*/(.*)\.html:\1:')" -M title-prefix="Nebojša Koturović" --toc --toc-depth=3 
	pandoc $< --template templates/post.latex --listings --pdf-engine=xelatex --resource-path="./out/img" \
		   --filter ./filters/pretty-date.py \
		   -o "./out/pdf/$(shell echo "$@" | sed -E 's:.*/(.*)\.html:\1:').pdf" \
	       -V colorlinks -M monofont=inconsolata -M mainfont="Open Sans" --toc --toc-depth=3 

out/blog.html: $(OUT) make_blog.py
	python3 make_blog.py
	pandoc -s out/blog.md -o out/blog.html --template templates/blog.html \
	   	   --css="./styles/common.css" --css="./styles/blog.css" -M title="Blog" -M title-prefix="Nebojša Koturović"
	rm out/blog.md

# Shortcuts

open: all
	open out/blog.html

# Get an ISO 8601 date.
date:
	date -u +"%Y-%m-%dT%H:%M:%SZ"

clean:
	rm -r out

hook:
	ln -s -f ../../.hooks/pre-commit ./.git/hooks/pre-commit

.PHONY: install
install:
	pip install -r requirements.txt
