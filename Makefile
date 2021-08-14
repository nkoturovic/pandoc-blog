POSTS=$(shell find src/posts/*)
# OUT contains all names of static HTML targets corresponding to markdown files
# in the posts directory.
OUT=$(patsubst src/posts/%.md, out/posts/%.html, $(POSTS))

all: $(OUT) index.html
	cp styles out/ -r
	cp src/img out/img -r

out/posts/%.html: src/posts/%.md
	pandoc -s --highlight-style=pygments -f markdown+fenced_divs -s $< -o $@ --template templates/post.html --css="../styles/common.css"
	# --toc --toc-depth=3 

index.html: $(OUT) make_index.py
	python3 make_index.py
	pandoc -s out/index.md -o out/index.html --template templates/index.html  --css="./styles/common.css" --css="./styles/index.css"
	rm out/index.md

# Shortcuts

open: all
	open index.html

# Get an ISO 8601 date.
date:
	date -u +"%Y-%m-%dT%H:%M:%SZ"

clean:
	rm -f out/index.html out/posts/* out/index.md
	rm out/styles -r
	rm out/img -r
	rm out/feed.json

hook:
	ln -s -f ../../.hooks/pre-commit ./.git/hooks/pre-commit

.PHONY: install
install:
	pip install -r requirements.txt
