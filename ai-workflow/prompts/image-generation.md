# Prompt: Image Sourcing

Used by **Quill** (content-writer agent) to create the two images required per post.

## Image Spec

Each post needs a dedicated folder and two images:

| File | Size | Used for |
|------|------|---------|
| `assets/img/postN/avatar.png` | 400×400 (square) | Blog post list thumbnail |
| `assets/img/postN/socialshare.png` | 1200×630 (wide) | Social sharing / og:image |

## Step 1: Create the folder

```bash
mkdir -p assets/img/post{{POST_N}}
```

---

## Step 2: Choose a metaphorical search keyword

Do NOT search for the literal topic. Think of a visual metaphor that conveys the *feeling or idea* behind the post.

Examples:
| Post topic | Bad keyword | Good metaphor keyword |
|-----------|-------------|----------------------|
| AI agents need process design | "AI agent" | "blueprint" or "architect" |
| dbt incremental models | "database" | "layers" or "foundation" |
| Data pipeline failures | "error" | "bridge" or "broken chain" |
| Power BI self-service myth | "dashboard" | "compass" or "map" |

Pick one keyword that a reader would look at and immediately *feel* the post's message, even before reading a word.

---

## Option A: Unsplash API (preferred — topic-relevant, free)

Requires `UNSPLASH_ACCESS_KEY` set in environment.

```bash
# Wide socialshare image (landscape)
SOCIAL_URL=$(curl -s "https://api.unsplash.com/search/photos?query={{KEYWORD}}&per_page=1&orientation=landscape" \
  -H "Authorization: Client-ID $UNSPLASH_ACCESS_KEY" \
  | jq -r '.results[0].urls.regular')

curl -sL "$SOCIAL_URL" -o assets/img/post{{POST_N}}/socialshare.png

# Square avatar image
AVATAR_URL=$(curl -s "https://api.unsplash.com/search/photos?query={{KEYWORD}}&per_page=1&orientation=squarish" \
  -H "Authorization: Client-ID $UNSPLASH_ACCESS_KEY" \
  | jq -r '.results[0].urls.small')

curl -sL "$AVATAR_URL" -o assets/img/post{{POST_N}}/avatar.png
```

---

## Option B: DALL-E API (AI-generated — best for abstract concepts)

Requires `OPENAI_API_KEY` set in environment.

```bash
IMAGE_URL=$(curl -s https://api.openai.com/v1/images/generations \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "dall-e-3",
    "prompt": "{{IMAGE_PROMPT}}",
    "size": "1792x1024",
    "quality": "standard",
    "n": 1
  }' | jq -r '.data[0].url')

curl -sL "$IMAGE_URL" -o assets/img/post{{POST_N}}/socialshare.png
curl -sL "https://picsum.photos/400/400" -o assets/img/post{{POST_N}}/avatar.png
```

---

## Option C: Picsum fallback (no API key — random, not topic-related)

Only use this if neither API key is available.

```bash
curl -sL "https://picsum.photos/1200/630" -o assets/img/post{{POST_N}}/socialshare.png
curl -sL "https://picsum.photos/400/400"  -o assets/img/post{{POST_N}}/avatar.png
```
