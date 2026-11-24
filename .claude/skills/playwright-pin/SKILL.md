---
name: playwright-pin
description: Pin a Playwright release's browsers in this repo. Use when Playwright reports a missing browser executable or wants a browser revision that is not installed, or when a project bumps its Playwright version.
---

Browsers come from a read-only Nix registry at `$PLAYWRIGHT_BROWSERS_PATH`, built by `modules/features/development/playwright.nix`. `npx playwright install` cannot add to it. A Playwright release gets its exact browsers by being listed in that file's `pins`.

Firefox and webkit exist only at pinned revisions. Chromium and ffmpeg fall back to the nixpkgs build at unpinned revisions, so they launch without a pin, just not at the exact version.

## Steps

1. **Version.** In the project: `jq -r .version node_modules/playwright-core/package.json`.
2. **Already pinned?** If the version is in `pins`, the registry is fine and the shell is stale: go to step 5.
3. **Hash.** `nix flake prefetch --json github:pietdevries94/playwright-web-flake/<version> | jq -r .hash`. A failure means upstream has no tag for that version yet: stop and tell the user.
4. **Pin.** Add `"<version>" = "<hash>";` to `pins`, keeping the list in version order.
5. **Apply.** The user rebuilds the system (it needs sudo). Shells opened before the rebuild keep the old registry; refresh one with:
   ```sh
   eval "$(grep -m1 PLAYWRIGHT_BROWSERS_PATH /etc/set-environment)"
   ```

Done when the firefox and webkit revisions the project expects are both in the registry:

```sh
jq -r '.browsers[] | select(.name == "firefox" or .name == "webkit") | "\(.name)-\(.revision)"' node_modules/playwright-core/browsers.json
ls "$PLAYWRIGHT_BROWSERS_PATH" | grep -E '^(firefox|webkit)-'
```

## Hash mismatch on an existing pin

Upstream re-tagged that version. Re-run step 3 and replace the hash.
