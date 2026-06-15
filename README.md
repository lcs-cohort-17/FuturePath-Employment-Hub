# 🛠️ Development & Git Guide

To keep our codebase from breaking, everyone must strictly follow this Git workflow.

---

## 📂 1. Core Branches & Rules
We use a two-tier branch system for development and deployment:
* **`dev`**: The main development branch. All daily feature and bugfix branches branch off from here and merge back into here.
* **`main`**: Final production branch. Code is only moved here at the end of a sprint (e.g., Sprint 1, Sprint 2) for final release.

⚠️ **Never push directly to `dev` or `main`.** Always create a dedicated branch.

---

## 🏷️ 2. Branch Naming Rules
Always create your branch from an up-to-date `dev` branch using these exact naming rules:

| Your Role / Task            | Branch Name Format                 | Real-World Example |
| :---                        | :---                               | :---                               |
| **Developers (Devs)**       | `your-name/dev/ticket-title`       | `jake/dev/sidebar-icons`           |
| **Quality Assurance (QA)**  | `your-name/qa/ticket-title`        | `alex/qa/automation-test`          |
| **Scrum Masters (SM)**      | `your-name/SM-team/branch-purpose` | `sarah/SM-team/repo-cleanup`       |
| **Bug Fixes**               | `bugfix/ticket-title`              | `bugfix/vite-config-crash`         |

---

## 💻 3. Your Daily Workflow (Terminal Commands)
Follow these exact terminal steps in order whenever you work on a task or bug fix:

### 🔄 Step A: Sync your machine with development
Before making a new branch, make sure your local machine has the latest remote updates from `dev`:
```bash
git checkout dev
git pull origin dev
```

### 🌿 Step B: Create your feature or bugfix branch
Create and switch to your new branch. Ensure it perfectly matches the formats in Section 2:
```bash
# For a feature:
git checkout -b your-name/dev/sidebar-icons

# For a bug fix:
git checkout -b bugfix/vite-config-crash
```

### 🚀 Step C: Your VERY FIRST Push (Setting Upstream)
The first time you push your brand-new branch to GitHub, you **must** link it to the server using the upstream flag:
```bash
git push -u origin HEAD
```
*💡 Tip: Using `HEAD` automatically copies your current branch name, preventing typing errors.*

### 💾 Step D: All Routine Daily Pushes
For all subsequent daily progress updates on this specific task, track, commit, and upload sequentially:
```bash
git add .
git commit -m "feat: short description" # or "fix: resolve crash"
git push
```

---

## 🚦 4. Getting Your Code Merged (The Quality & SM Handoff)
Once your assignment or bug fix is complete, follow this process to submit your work:

- [ ] **1. Open a Pull Request**: Go to GitHub and open a PR from your branch into the target **`dev`** branch.
- [ ] **2. Use the Template**: Fill out the PR description using our official **🚀 PULL REQUEST DETAILS** template.
- [ ] **3. Assign Reviewers**: Navigate to the right-hand panel on the PR page, click **Reviewers**, and tag your team handles:
  * Tag your **Scrum Masters** for workflow approval: `@lcs-cohort-17/sm-team`
  * Tag your **QA Team** for functional testing: `@lcs-cohort-17/qa-team`
- [ ] **4. Hands Off**: Your job is done here! The Scrum Master and QA will test your build. Once approved, the Scrum Master will coordinate with the Product Owners (POs) for final production deployment to `main` at the end of the sprint.
