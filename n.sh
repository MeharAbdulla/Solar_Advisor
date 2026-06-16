#!/bin/bash

# Your GitHub repo
REPO_URL="https://github.com/MeharAbdulla/Solar_Advisor.git"

# Path to your local repo
REPO_PATH="$1"
if [ -z "$REPO_PATH" ]; then
  echo "Usage: $0 <repo-path>"
  exit 1
fi

# Create repo folder if it doesn't exist
mkdir -p "$REPO_PATH"
cd "$REPO_PATH" || { echo "Cannot enter repo path"; exit 1; }

# Initialize git if not initialized
if [ ! -d ".git" ]; then
  git init
  echo "# Solar_Advisor" >> README.md
  git add README.md
  git commit -m "first commit"
  git branch -M main
  git remote add origin "$REPO_URL"
fi


# ==========================================================
# 2 Commit Days Per Week (Between 11/11/2025 - 12/11/2025)
# ==========================================================

DATES=(
    "2026-04-01",
    "2026-04-02",
    "2026-04-03",
    "2026-04-04",
    "2026-04-05",
    "2026-04-06"
)



# Commit messages
MESSAGES=(
"Update code"
"Refactor script"
"Add feature"
"Minor fix"
"Train AI model"
"Optimize ML pipeline"
"Implement LSTM network"
"Add named entity recognition"
"Optimize text classification"
"Experiment with GPT-based model"
"Enhance speech-to-text accuracy"
"Deploy machine learning model"
"Add transformer-based summarization"
"Improve language generation"
"Integrate AI-powered recommendation system"
"Run hyperparameter tuning"
"Evaluate model performance"
)


# Commit times
TIMES=(
"09:00:00"
"13:30:00"
"17:45:00"
"10:15:00"
"14:55:00"
"19:10:00"
)

# Create backdated commits
for DATE in "${DATES[@]}"; do
  NUM_COMMITS=$((RANDOM % 3 + 1))  # 1–3 commits per commit day

  for ((i=0; i<NUM_COMMITS; i++)); do
    MSG_INDEX=$((RANDOM % ${#MESSAGES[@]}))
    MSG=${MESSAGES[$MSG_INDEX]}

    TIME_INDEX=$((RANDOM % ${#TIMES[@]}))
    COMMIT_TIME=${TIMES[$TIME_INDEX]}

    # Dummy change
    echo "$DATE $COMMIT_TIME - $MSG" >> commits.log
    git add commits.log

    # Backdated commit
    GIT_COMMITTER_DATE="$DATE $COMMIT_TIME" \
    git commit --date="$DATE $COMMIT_TIME" -m "$MSG"
  done
done

# Push commits
git push -u origin main

echo "✅ All commits created and pushed!"
