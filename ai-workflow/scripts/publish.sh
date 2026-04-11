#!/bin/bash
# publish.sh — stage, commit, and push a new blog post
# Usage: ./publish.sh "YYYY-MM-DD-slug"

set -e

SLUG=$1

if [ -z "$SLUG" ]; then
  echo "Usage: publish.sh <post-slug>  (e.g. 2026-04-11-my-post)"
  exit 1
fi

POST_FILE="_posts/${SLUG}.md"
IMG_FILE="assets/img/${SLUG}.png"

if [ ! -f "$POST_FILE" ]; then
  echo "Post not found: $POST_FILE"
  exit 1
fi

echo "Staging files..."
git add "$POST_FILE"
[ -f "$IMG_FILE" ] && git add "$IMG_FILE"

echo "Committing..."
git commit -m "add post: ${SLUG}"

echo "Pushing to master..."
git push origin master

echo "Done. Post will be live on ciaeric.github.io within ~1-2 minutes."
