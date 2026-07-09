Git Workshop: Branching, Merging, Reset, Rebase

This folder contains step-by-step commands and explanations to complete the requested git exercises. Replace placeholders like <YOUR_USERNAME>, <REPO_NAME>, and <MONGODB_URI> where applicable.

1) Create a new GitHub repository and clone via SSH

# On GitHub (UI) create a new repo named "<REPO_NAME>" and make it public/private as needed.
# Locally (generate SSH key if needed):
ssh-keygen -t ed25519 -C "your_email@example.com"
# Copy ~/.ssh/id_ed25519.pub to GitHub -> Settings -> SSH and GPG keys

# Clone via SSH:
git clone git@github.com:<YOUR_USERNAME>/<REPO_NAME>.git
cd <REPO_NAME>

# Create a branch named after your username and add Flask project
git checkout -b <YOUR_USERNAME>
# Copy your Flask project files into this repo (e.g., flask_task/)
git add flask_task
git commit -m "Add Flask project on branch <YOUR_USERNAME>" \
  -m "Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
git push -u origin <YOUR_USERNAME>

# Merge into main (open PR on GitHub or merge locally):
git checkout main
git pull origin main
git merge --no-ff <YOUR_USERNAME>
# Resolve conflicts if any, then:
git push origin main


2) Create branch <your_name>_new and update backend JSON

git checkout -b <YOUR_USERNAME>_new
# Edit flask_task/backend/data.json (update contents)
# Stage and commit
git add flask_task/backend/data.json
git commit -m "Update backend data.json in <YOUR_USERNAME>_new" \
  -m "Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
git push -u origin <YOUR_USERNAME>_new

# Merge into main (prefer GitHub PR or locally):
git checkout main
git pull origin main
git merge <YOUR_USERNAME>_new
# If conflicts occur and you want to accept changes from <YOUR_USERNAME>_new:
# During conflict resolution, use the content from the feature branch. Example (in a file):
# 1) Open conflicted file, keep the <<<<<<< HEAD / ======= / >>>>>>> branch sections and choose the branch's content
# or use the command to checkout branch version for a file:
# git checkout --theirs -- path/to/conflicted_file

# After resolving conflicts
git add path/to/conflicted_file
git commit -m "Resolve merge conflicts accepting <YOUR_USERNAME>_new changes" \
  -m "Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
git push origin main


3) Create master_1 and master_2 branches and implement features

# Create branches from main:
git checkout main
git pull origin main
git checkout -b master_1
git checkout -b master_2

# In master_1 (To-Do frontend page):
# Add templates/todo.html and route (or modify existing frontend files)
# Example commit:
git add templates/todo.html
git commit -m "Add To-Do page (form) in master_1" \
  -m "Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
git push -u origin master_1

# In master_2 (backend /submittodoitem):
# Add route to flask_task/app.py (or a new blueprint) that accepts POST and inserts into MongoDB
# Example commit:
git add flask_task/app.py
git commit -m "Add /submittodoitem route in master_2" \
  -m "Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
git push -u origin master_2

# Merge both branches into main (order doesn't matter). Prefer PRs for visibility.
# Merge master_1:
git checkout main
git pull origin main
git merge master_1
git push origin main
# Merge master_2:
git merge master_2
git push origin main


4) Enhance To-Do form in master_1 with incremental commits

git checkout master_1
# Edit templates/todo.html: add Item ID field
git add templates/todo.html
git commit -m "Add Item ID field to To-Do form" \
  -m "Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"

# Add Item UUID field
# Edit file again, then:
git add templates/todo.html
git commit -m "Add Item UUID field to To-Do form" \
  -m "Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"

# Add Item Hash field
# Edit file again, then:
git add templates/todo.html
git commit -m "Add Item Hash field to To-Do form" \
  -m "Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"

git push origin master_1

# Merge master_1 into main
git checkout main
git pull origin main
git merge master_1
git push origin main


5) Git reset and re-commit flow on main

# Suppose main has all three commits from merging master_1. To roll back to the commit where only Item ID was added:
# Find the commit hash of the first commit (e.g., use git log --oneline)
# Then reset soft to that commit:
git checkout main
# Assuming <COMMIT_HASH_ITEM_ID> is the commit where only Item ID was added:
git reset --soft <COMMIT_HASH_ITEM_ID>
# This leaves changes staged. Re-commit these staged changes with a new message if desired:
git commit -m "Keep only Item ID changes on main" \
  -m "Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
git push --force-with-lease origin main


6) Rebase main into master_1 preserving commits

# Update master_1 by rebasing onto main
git checkout master_1
git fetch origin
git rebase main
# If conflicts occur during rebase, resolve them, then:
# git add <resolved_files>
# git rebase --continue
# After successful rebase, push the updated branch (force-push required):
git push --force-with-lease origin master_1


Notes & Safety
- Never force-push to shared branches without coordination. Use --force-with-lease to reduce accidental overwrite risk.
- Back up important branches before destructive operations.
- Use PRs for merges when collaborating to allow code review and safer conflict resolution.


Example /submittodoitem Flask handler (outline)

from flask import Flask, request, jsonify
from pymongo import MongoClient
import os

app = Flask(__name__)

client = MongoClient(os.environ.get('MONGODB_URI'))
db = client.get_default_database() or client['test']

@app.route('/submittodoitem', methods=['POST'])
def submit_todo():
    itemName = request.form.get('itemName')
    itemDescription = request.form.get('itemDescription')
    if not itemName:
        return jsonify({'error': 'itemName required'}), 400
    db.todoitems.insert_one({'itemName': itemName, 'itemDescription': itemDescription})
    return jsonify({'status': 'ok'})


Commit and push example

# After making changes locally:

git add .
git commit -m "Implement X" -m "Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
git push origin <branch-name>


Screenshots & Submission
- Take screenshots of commands and outputs for each step.
- Prepare a Word/Google Doc with explanations, commands, and screenshots.
- Add the doc to this repo under git_workshop/submission.docx and push.

End of instructions.
