# Contributing

## Keep `main` green

Every push to `main` runs CI (`.github/workflows/flutter-ci.yml`) in this order:

```
format check -> analyze -> test -> build -> deploy-live -> Lighthouse
```

If any step fails, every step after it is skipped. One unformatted file therefore means **nothing deploys**, and the site stays on the last good build until `main` is fixed.

## Enable the pre-push hook (once per clone)

```bash
make hooks
# or, without make (e.g. Windows):
git config core.hooksPath .githooks
```

`.githooks/pre-push` then runs before each `git push`:

| Push to | Checks | Time |
|---|---|---|
| any branch | `dart format` check, `flutter analyze` | ~15 s |
| `main` | the above plus `flutter test` | ~2 min |

When a check fails, the push stops and the output shows what to fix. For formatting, run `make format` (or `dart format lib/ test/`), commit, and push again. In an emergency, `git push --no-verify` skips the checks.

Windows: Git for Windows runs the hook through its bundled shell, so `flutter` and `dart` need to be on the `PATH` that Git Bash sees.

## Prefer pull requests to direct pushes

A pull request runs the same checks and deploys a preview channel before anything reaches the live site. To make this mandatory, turn on branch protection for `main` on GitHub: **Settings → Branches → Add rule**, then require a pull request and the `analyze-test` and `build-web` status checks.
