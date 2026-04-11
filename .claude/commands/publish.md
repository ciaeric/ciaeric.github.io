Publish an approved blog post to ciaeric.github.io.

## Steps

1. Identify the post to publish:
   - Use the post I name, or the most recent file in `_posts/` if unspecified

2. Confirm both files exist:
   - `_posts/YYYY-MM-DD-slug.md`
   - `assets/img/postN/avatar.png`
   - `assets/img/postN/socialshare.png`
   
   If images are missing, warn me before continuing.

3. Show me exactly what will be committed and ask for confirmation:
   ```
   Ready to publish:
     _posts/YYYY-MM-DD-slug.md
     assets/img/postN/avatar.png
     assets/img/postN/socialshare.png
   
   Proceed? (yes/no)
   ```

4. After confirmation, run:
   ```bash
   bash ai-workflow/scripts/publish.sh YYYY-MM-DD-slug
   ```

5. Confirm success and remind me:
   - Site will be live at ciaeric.github.io within ~1-2 minutes
   - Check GitHub Actions for deploy status if needed
