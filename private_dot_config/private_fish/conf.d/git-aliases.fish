# Base
alias g='git'

# Custom / Personal
alias git-fullclean='git reset HEAD && git checkout . && git clean -fd'
alias gFC='git-fullclean'
alias g-='git switch -'

# Add
alias ga='git add'
alias gaa='git add --all'

# Branch
alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch --delete'

# Checkout
alias gco='git checkout'
alias gcor='git checkout --recurse-submodules'
alias gcb='git checkout -b'
alias gcB='git checkout -B'

# Switch (modern checkout for branches)
alias gsw='git switch'
alias gswc='git switch --create'

# Cherry-pick
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

# Clean / Clone
alias gclean='git clean --interactive -d'

# Commit
alias gc='git commit --verbose'
alias gca='git commit --verbose --all'
alias gcmsg='git commit --message'
alias gcsm='git commit --signoff --message'

# Config
alias gcf='git config --list'

# Fetch
alias gf='git fetch'
alias gfa='git fetch --all --tags --prune --jobs=10'
alias gfo='git fetch origin'

# Log
alias glo='git log --oneline --decorate'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
alias glola='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'
alias glols='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat'
alias glod='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'
alias glods='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glg='git log --stat'
alias glgp='git log --stat --patch'

# Merge
alias gm='git merge'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gms='git merge --squash'
alias gmff='git merge --ff-only'
alias gmtl='git mergetool --no-prompt'
alias gmtlvim='git mergetool --no-prompt --tool=vimdiff'

# Pull
alias gl='git pull'

# Push
alias gp='git push'
alias gpd='git push --dry-run'
alias gpv='git push --verbose'

# Rebase
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'
alias grbo='git rebase --onto'
alias grbs='git rebase --skip'

# Reflog
alias grf='git reflog'

# Restore
alias grs='git restore'
alias grss='git restore --source'
alias grst='git restore --staged'

# Revert
alias grev='git revert'
alias greva='git revert --abort'
alias grevc='git revert --continue'

# Remove
alias grm='git rm'
alias grmc='git rm --cached'

# Show
alias gsh='git show'
alias gsps='git show --pretty=short --show-signature'

# Stash
alias gsta='git stash push'
alias gstall='git stash --all'
alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --patch'
alias gstu='git stash push --include-untracked'

# Status
alias gst='git status'
alias gss='git status --short'
alias gsb='git status --short --branch'

# Submodule
alias gsi='git submodule init'
alias gsu='git submodule update'

# Tag
alias gta='git tag --annotate'
alias gts='git tag --sign'
alias gtv='git tag | sort -V'
alias gdct='git describe --tags (git rev-list --tags --max-count=1)'

# Worktree
alias gwt='git worktree'
alias gwta='git worktree add'
alias gwtls='git worktree list'
alias gwtmv='git worktree move'
alias gwtrm='git worktree remove'

# Misc
alias gbl='git blame -w'
alias gcount='git shortlog --summary --numbered'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias gfg='git ls-files | grep'
alias gignore='git update-index --assume-unchanged'
alias gunignore='git update-index --no-assume-unchanged'
alias ggpur='git pull --rebase origin (git_current_branch)'
