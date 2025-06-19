#!/bin/bash

# Step 1: Get the root of the Git repo
REPO_ROOT=$(git rev-parse --show-toplevel)
if [ $? -ne 0 ]; then
  echo "Not inside a Git repo. Aborting."
  exit 1
fi

CLI_DIR="C:/Users/admin_qlab/Documents/IBM_QSE_2.2.1_CLI_EN/CLI"

cd "CLI_DIR" || {
  echo "Failed to cd directory with Quantum Safe Exlplorer CLI."
  echo "Directory provided was C:\Users\admin_qlab\Documents\IBM_QSE_2.2.1_CLI_EN\CLI"
  exit 1
}

# Step 2: Get the list of staged files
STAGED_FILES=$(git diff --cached --name-only)

# Step 3: Initialize an empty list of extensions
EXTENSIONS=()

# Step 4: Check for each supported type
for file in $STAGED_FILES; do
  case "$file" in
    *.py)    [[ ! " ${EXTENSIONS[*]} " =~ ".py" ]] && EXTENSIONS+=(".py") ;;
    *.cpp)   [[ ! " ${EXTENSIONS[*]} " =~ ".cpp" ]] && EXTENSIONS+=(".cpp") ;;
    *.go)    [[ ! " ${EXTENSIONS[*]} " =~ ".go" ]] && EXTENSIONS+=(".go") ;;
    *.dart)  [[ ! " ${EXTENSIONS[*]} " =~ ".dart" ]] && EXTENSIONS+=(".dart") ;;
    *.java)  [[ ! " ${EXTENSIONS[*]} " =~ ".java" ]] && EXTENSIONS+=(".java") ;;
    *.cs)    [[ ! " ${EXTENSIONS[*]} " =~ ".cs" ]] && EXTENSIONS+=(".cs") ;;
    *.c)     [[ ! " ${EXTENSIONS[*]} " =~ ".c" ]] && EXTENSIONS+=(".c") ;;
    *.jar)   [[ ! " ${EXTENSIONS[*]} " =~ ".jar" ]] && EXTENSIONS+=(".jar") ;;
  esac
done

# Step 5: If no relevant extensions, exit early
if [ ${#EXTENSIONS[@]} -eq 0 ]; then
  echo "o supported file types staged. Skipping hook."
  exit 0
fi

# Step 6: Build comma-separated list of extensions
EXT_LIST=$(IFS=, ; echo "${EXTENSIONS[*]}")

# Step 7: Run the command with dynamic -l argument
./cli.sh -i "$CLI_DIR" -l "$EXT_LIST"

# Exit with success
exit 0

