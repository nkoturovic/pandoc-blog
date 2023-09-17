#!/usr/bin/env python

# make_blog.py generates a Markdown document representing the blog index.
# Ideally, this should only contain the list of links to posts and whatever
# metadata should be listed in those posts. For header/footer information, it
# will probably be easier to modify templates/blog.html.

from os import listdir
import frontmatter
from datetime import datetime
from dateutil.parser import parse
import pytz
# import jsonfeed as jf

OUTPUT_FOLDER = "out"
MARKDOWN_POSTS_PATH = "./src/post"
OUT_POSTS_PATH = "post"
STATIC_FILES_PATH = OUTPUT_FOLDER + "/" + OUT_POSTS_PATH

isNaive = lambda d: d.tzinfo is None or d.tzinfo.utcoffset(d) is None

def getMetadata(static_post):
    post = frontmatter.load(MARKDOWN_POSTS_PATH + "/" + static_post)
    out = {}
    out['title'] = post.get('title', static_post[:-3])

    if 'date' in post:
        # ISO 8601 dates are automatically datetimes.
        out['date'] = post.get('date')
    else:
        print("[WARN] no date for post", static_post)
        out['date'] = datetime.now(tz=pytz.UTC)
    # If we don't have timezone info, we assume UTC.
    if isNaive(out['date']):
        print("[WARN] No time zone for date; assuming UTC")
        out['date'] = out['date'].replace(tzinfo=pytz.UTC)

    out['abstract'] = post.get('abstract')
    out['draft'] = post.get('draft')
    out['filename'] = static_post

    return out

def getStaticFilename(post_metadata):
    return post_metadata['filename'][:-3] + ".html"

def main():
    static_posts = listdir(MARKDOWN_POSTS_PATH)
    metadatas = [getMetadata(fn) for fn in static_posts]
    # Don't index drafts.
    metadatas = [m for m in metadatas if not m['draft']]
    metadatas.sort(key=lambda md: md['date'], reverse=True)

    # Generating index.html
    with open("./" + OUTPUT_FOLDER + "/blog.md", "w") as f:
        if len(metadatas) == 0:
            f.write("## There aren't any posts yet.\n")
        else:
            for metadata in metadatas:
                f.write('<div class="post-item">\n')
                f.write("## [{}]({})\n".format(
                    metadata['title'],
                    OUT_POSTS_PATH + "/" + getStaticFilename(metadata)
                ))
                if metadata['abstract']:
                    f.write("{} &middot; {}\n".format(
                        metadata['date'].strftime("%B %d, %Y"),
                        metadata['abstract']
                    ))
                f.write("\n")
                f.write("</div>")

    # Construct a JSON feed.
    # feed = jf.Feed("blog")
    # for metadata in metadatas:
    #     url = getStaticFilename(metadata)
    #     item = jf.Item(
    #         url, # url as primary ID.
    #         url=url,
    #         title=metadata['title']
    #     )
    #     # These components may or may not be defined.
    #     if metadata['date']:
    #         # isoformat is RFC-compatible iff the datetime is timezone-aware.
    #         item.date_published = metadata['date'].isoformat()

    #     # Set abstract if available.
    #     if metadata['abstract']:
    #         item.summary = metadata['abstract']
    #     # Set content_html to full generated contents.
    #     # NOTE: relative links (incl. img sources) won't work in a feed reader, but
    #     # this is a better best effort than just including abstracts.
    #     with open(STATIC_FILES_PATH + "/" + getStaticFilename(metadata), "r") as html:
    #         item.content_html = html.read()

    #     feed.items.append(item)

    # with open(OUTPUT_FOLDER + "/feed.json", "w") as f:
    #     f.write(feed.toJSON(indent="\t"))

if __name__ == "__main__":
    main()
