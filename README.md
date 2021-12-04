# About this Repo

+ This repo is a fork of [lukasschwab/pandoc-blog](https://github.com/lukasschwab/pandoc-blog/)
+ You can see live demo on: [View a demo site.](https://www.kotur.me/)

# pandoc-blog

This is a *very* basic Pandoc static site generator.

I've avoided writing CSS beyond some very basic readability improvements/demonstrating that CSS can be added. The goal here is just to populate well-structured HTML documents and a generated JSON feed. [View a demo site.](https://www.kotur.me/)

Deeply unattractive out of the box? Yes. Easy to customize? I hope so.

## Requirements

+ `pandoc`
+ Python 3
+ Python dependencies listed in `requirements.txt`. Install them with `make install`.
+ `Inconsolata` font on system - copy from `./blog-src/font` or install via package manager
+ `Open Sans` font on system - copy from `./blog-src/font` or install via package manager

## Usage

1. Clone this repository.
2. Write Pandoc-compatible Markdown files in `posts`. These should include YAML frontmatter for generating the index:
    + `title`: a human-readable title for this post.
    + `date`: an ISO 8601 date (`make date`).
    + `abstract`: a summary you want to appear on the index. This can include valid Pandoc markdown.
3. Run `make all` to build an HTMl file for each Markdown page and generate `index.html`.

### Utilities

+ `make requirements.txt`: install dependencies for `make_index.py`.
+ `make hook`: configure a git hook to run `make all` before each commit (so each commit contains an up-to-date static site).

## How it works

`Makefile` is the most robust guide, but here's a high-level overview.

1. `pandoc` transforms each Markdown post in `posts` into a static HTML file in `gen`. The HTML is structured using `templates/post.html` and styled with `styles/shared.css`.

2. `make_index.py` reads the YAML frontmatter of every Markdown post in `posts` and transforms this into an intermediate Markdown document of headers and metadata, `index.md`.

3. `pandoc` transforms `index.md` into `index.html`. Unlike the posts, this index file is structured using `templates/index.html` and it's styled with *both* `styles/shared.css` and `styles/index.css` (with the latter styles overriding the former.

## Customization

A general rule of thumb: changes to the HTML are predictable; changes to pre-`pandoc` Markdown are unpredictable. Markdown intermediates (like `make_index.py` uses for the time being) are antipatterns.

+ Want to change how posts are represented in the index?<br>Modify `make_index.py`.

+ Want to add static elements, e.g. a section with "about me" info or social links?<br>Modify `templates/index.html` to only change the index.<br>Modify `templates/post.html` to only change the post pages.

+ Want to change how the index is styled?<br>Modify `styles/index.css`.

+ Want to change how the whole generated site is styled?<br>Modify `styles/common.css`.

### Fenced `div`s

`pandoc-blog` converts Markdown to HTML with [`pandoc`'s `fenced_divs` extension](https://pandoc.org/MANUAL.html#extension-fenced_divs) enabled. You can use this to define a `div`––complete with HTML attributes––in your markup:

```markdown
This text is outside of the fenced `div`.

::: {.addendum date="Oct. 12, 2020"}

This text is in a div with class `addendum` and attribute `date="Oct. 12, 2020"`.

:::

This text is outside of the fenced `div`.
```

You can modify [styles/common.css](styles/common.css) to apply styles to those fenced `div`s and their children:

```css
/* Style addenda. */
div.addendum {
  border: 1px solid grey;
  padding: 0 1em;
}

/* Include `date` attribute above addenda. */
div.addendum::before {
  display: block;
  text-align: center;
  color: grey;
  width: 100%;
  margin-top: 1em;
  content: "Addendum " attr(data-date);
}
```

## To do

+ `make_index.py` should be extended to read a greater variety of pandoc-supported YAML frontmatter and read full-blog metadata defined in some root YAML file.

+ Consider rolling table styles and utility classes into this repo.
