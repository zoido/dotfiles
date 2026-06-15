# Base
abbr -a g git

# Custom / Personal
abbr -a gFC 'git reset HEAD && git checkout . && git clean -fd'
abbr -a ggg 'git switch -'
abbr -a ggcm 'git switch (git_main_branch) && git pull && git fetch --all --tags --prune --jobs=10 && gh poi'
abbr -a pb --command git '(git_parent_branch)'
abbr -a gcm 'git switch (git_main_branch)'
abbr -a gcd 'git switch (git_develop_branch)'
abbr -a gswm 'git switch (git_main_branch)'
abbr -a gswd 'git switch (git_develop_branch)'

# Add
abbr -a ga 'git add'
abbr -a gaa 'git add --all'

# Branch
abbr -a gb 'git branch'
abbr -a gba 'git branch --all'
abbr -a gbd 'git branch --delete'

# Checkout
abbr -a gco 'git checkout'
abbr -a gcor 'git checkout --recurse-submodules'
abbr -a gcb 'git checkout -b'
abbr -a gcB 'git checkout -B'

# Switch (modern checkout for branches)
abbr -a gsw 'git switch'
abbr -a gswc 'git switch --create'

# Cherry-pick
abbr -a gcp 'git cherry-pick'
abbr -a gcpa 'git cherry-pick --abort'
abbr -a gcpc 'git cherry-pick --continue'

# Clean / Clone
abbr -a gclean 'git clean --interactive -d'

# Commit
abbr -a gc 'git commit --verbose'
abbr -a gca 'git commit --verbose --all'
abbr -a gcmsg 'git commit --message'
abbr -a gcsm 'git commit --signoff --message'

# Config
abbr -a gcf 'git config --list'

# Diff
abbr -a gd 'git diff'
abbr -a gdca 'git diff --cached'
abbr -a gdcw 'git diff --cached --word-diff'
abbr -a gds 'git diff --staged'
abbr -a gdw 'git diff --word-diff'
abbr -a gdup 'git diff @{upstream}'
abbr -a gdt 'git diff-tree --no-commit-id --name-only -r'
abbr -a gdp 'git diff (gBP)'

abbr --add dn --command git --command gd --command gdw --command gdp '| diffnav'

# Fetch
abbr -a gf 'git fetch'
abbr -a gfa 'git fetch --all --tags --prune --jobs=10'
abbr -a gfo 'git fetch origin'

# Log
abbr -a glo 'git log --oneline --decorate'
abbr -a glog 'git log --oneline --decorate --graph'
abbr -a gloga 'git log --oneline --decorate --graph --all'
abbr -a glol 'git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
abbr -a glola 'git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'
abbr -a glols 'git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat'
abbr -a glod 'git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'
abbr -a glods 'git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short'
abbr -a glgg 'git log --graph'
abbr -a glgga 'git log --graph --decorate --all'
abbr -a glgm 'git log --graph --max-count=10'
abbr -a glg 'git log --stat'
abbr -a glgp 'git log --stat --patch'

# Merge
abbr -a gm 'git merge'
abbr -a gma 'git merge --abort'
abbr -a gmc 'git merge --continue'
abbr -a gms 'git merge --squash'
abbr -a gmff 'git merge --ff-only'
abbr -a gmtl 'git mergetool --no-prompt'

# Pull
abbr -a gl 'git pull'

# Push
abbr -a gp 'git push'
abbr -a gpd 'git push --dry-run'
abbr -a gpv 'git push --verbose'

# Rebase
abbr -a grb 'git rebase'
abbr -a grba 'git rebase --abort'
abbr -a grbc 'git rebase --continue'
abbr -a grbi 'git rebase --interactive'
abbr -a grbo 'git rebase --onto'
abbr -a grbs 'git rebase --skip'

# Reflog
abbr -a grf 'git reflog'

# Restore
abbr -a grs 'git restore'
abbr -a grss 'git restore --source'
abbr -a grst 'git restore --staged'

# Revert
abbr -a grev 'git revert'
abbr -a greva 'git revert --abort'
abbr -a grevc 'git revert --continue'

# Remove
abbr -a grm 'git rm'
abbr -a grmc 'git rm --cached'

# Show
abbr -a gsh 'git show'
abbr -a gsps 'git show --pretty=short --show-signature'

# Stash
abbr -a gsta 'git stash push'
abbr -a gstall 'git stash --all'
abbr -a gstaa 'git stash apply'
abbr -a gstc 'git stash clear'
abbr -a gstd 'git stash drop'
abbr -a gstl 'git stash list'
abbr -a gstp 'git stash pop'
abbr -a gsts 'git stash show --patch'
abbr -a gstu 'git stash push --include-untracked'

# Status
abbr -a gst 'git status'
abbr -a gss 'git status --short'
abbr -a gsb 'git status --short --branch'

# Submodule
abbr -a gsi 'git submodule init'
abbr -a gsu 'git submodule update'

# Tag
abbr -a gta 'git tag --annotate'
abbr -a gts 'git tag --sign'
abbr -a gtv 'git tag | sort -V'
abbr -a gdct 'git describe --tags (git rev-list --tags --max-count=1)'

# Worktree
abbr -a gwt 'git worktree'
abbr -a gwta 'git worktree add'
abbr -a gwtls 'git worktree list'
abbr -a gwtmv 'git worktree move'
abbr -a gwtrm 'git worktree remove'

# Misc
abbr -a gbl 'git blame -w'
abbr -a gcount 'git shortlog --summary --numbered'
abbr -a gignored 'git ls-files -v | grep "^[[:lower:]]"'
abbr -a gfg 'git ls-files | grep'
abbr -a gignore 'git update-index --assume-unchanged'
abbr -a gunignore 'git update-index --no-assume-unchanged'
abbr -a ggpur 'git pull --rebase origin (git_current_branch)'
