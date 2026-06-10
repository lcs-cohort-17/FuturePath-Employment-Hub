# Contributing to FuturePath

This guide covers everything you need to know to contribute correctly. Please read your relevant section fully before getting started.

---

## For developers

### Daily workflow

#### Step 1 — Sync with dev

Always start your day by pulling the latest code from `dev`:

```bash
git checkout dev
git pull origin dev
```

This ensures you have everyone's latest approved work before you start.

---

#### Step 2 — Create your feature branch

Create a new branch from `dev` using the correct naming format:

```bash
git checkout -b your-name/feature/screen-name
```

See branch naming rules below.

---

#### Step 3 — First push (setting upstream)

The first time you push your new branch, link it to GitHub:

```bash
git push -u origin HEAD
```

Using `HEAD` automatically copies your branch name — no typing errors.

---

#### Step 4 — Commit regularly throughout the day

Save your progress often:

```bash
git add .
git commit -m "feat: short description of what changed"
git push
```

Do not wait until the end of the day to commit. Small, frequent commits are better than one large one.

---

#### Step 5 — Open a pull request when your task is done

1. Go to the repository on GitHub
2. Open a Pull Request from your feature branch into `dev`
3. Fill in the PR description using the template — every field matters
4. Add a reviewer using the **Reviewers panel** on the right side of the PR page
5. Wait for approval — do not merge your own PR

---

#### Step 6 — Fixing a bug assigned to you

When a PO assigns a bug Issue to you:

1. Note the Issue number (e.g. `#12`) — you will need it
2. Pull the latest `dev` before starting:

```bash
git checkout dev
git pull origin dev
```

3. Create a fix branch:

```bash
git checkout -b bugfix/short-description
```

4. Fix the bug, commit, and push
5. Open a PR and include this in the description:

```
Fixes #12
```

This automatically closes the Issue when your PR is merged. Do not close the Issue manually.

---

### Branch naming

| Type | Format | Example |
|---|---|---|
| Flutter feature | `your-name/feature/screen-name` | `jake/feature/home-screen` |
| Bug fix | `bugfix/short-description` | `bugfix/search-filter-crash` |
| Chore / config | `chore/short-description` | `chore/update-gitignore` |

---

### Commit message format

| Prefix | When to use | Example |
|---|---|---|
| `feat:` | New screen or feature | `feat: add programme directory screen` |
| `fix:` | Bug fix | `fix: search bar not filtering results` |
| `chore:` | Config or cleanup | `chore: update pubspec dependencies` |
| `style:` | UI tweaks only | `style: adjust card padding on home screen` |

---

### Rules

- Never push directly to `dev` or `main`
- Never merge your own PR
- Always pull from `dev` at the start of the day
- One branch per task — do not mix multiple screens in one branch
- Keep API keys out of the repo — use a `.env` file listed in `.gitignore`
- Delete your feature branch after it has been merged

---

## For scrum masters

Your role in the bug process is to be the first line of quality control — you are the bridge between what the team builds and what the POs need to know about.

### When you find a bug

Do not message the POs or developers directly. Follow these steps:

1. Go to the **Issues** tab on GitHub
2. Click **New Issue**
3. Select the **Bug Report** template
4. Fill in every section — the more detail the better
5. Attach screenshots or a screen recording if you can
6. Set the priority field honestly based on how badly it breaks the app
7. Submit the Issue — the POs will pick it up from there

### What happens after you submit

- Dominic or Tylor will review the Issue, add labels, and assign it to a developer
- The developer will create a `bugfix/` branch, fix it, and open a PR referencing your Issue
- When the PR is merged the Issue closes automatically — you will see it move to closed
- You do not need to follow up or chase — the Issue tracker handles it

### Priority guide for bug reports

Use this to decide what priority to set when filling in the template:

| Priority | When to use | Example |
|---|---|---|
| 🔴 Critical | App crashes or a screen is completely broken | Home screen won't load |
| 🟠 High | Feature doesn't work but app still runs | Search returns no results |
| 🟡 Medium | Something looks wrong or behaves unexpectedly | Wrong programme details showing |
| 🟢 Low | Minor visual issue, cosmetic only | Button padding slightly off |

### What not to do

- Do not report bugs in PR comments — Issues are the only place bugs are tracked
- Do not assign the Issue yourself — that is the PO's job during triage
- Do not message a developer directly about a bug — log it first so there is a record

---

## Branch structure reference

```
main          ← sprint-complete, demo-ready only
dev           ← active integration branch (source of truth)
your-name/feature/home-screen
your-name/feature/programme-directory
your-name/feature/opportunities
your-name/feature/applicant-profile
bugfix/description
```
