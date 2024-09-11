# Simple aliases using Set-Alias
Set-Alias g git

function Get-GitAddPatch {
    git add -p $args
}
Set-Alias ga Get-GitAddPatch

function Get-GitAddAll {
    git add -A $args
}
Set-Alias gaa Get-GitAddAll

function Get-GitAdd {
    git add $args
}
Set-Alias gadd Get-GitAdd

function Get-GitCommit {
    git commit $args
}
Set-Alias gcmm Get-GitCommit

function Get-GitCommitMessage {
    git commit -m $args
}
Set-Alias gcmsg Get-GitCommitMessage

function Get-GitCheckout {
    git checkout $args
}
Set-Alias gco Get-GitCheckout

function Get-GitCheckoutAll {
    git checkout -- .
}
Set-Alias gcoall Get-GitCheckoutAll

function Get-GitPrettyDiff {
    dot git pretty-diff $args
}
Set-Alias gd Get-GitPrettyDiff

function Get-GitStatus {
    git status $args
}
Set-Alias gst Get-GitStatus

function Get-GitStatusShortBranch {
    git status -sb $args
}
Set-Alias gs Get-GitStatusShortBranch

function Get-GitFetch {
    git fetch --all -p $args
}
Set-Alias gf Get-GitFetch

function Get-GitPush {
    git push $args
}
Set-Alias gpush Get-GitPush

function Get-GitPushForce {
    git push --force $args
}
Set-Alias gpsf Get-GitPushForce

function Get-GitPull {
    git pull origin $args
}
Set-Alias gpu Get-GitPull

function Get-GitPullRebase {
    git pull --rebase --autostash $args
}
Set-Alias gpl Get-GitPullRebase

function Get-GitBranch {
    git branch $args
}
Set-Alias gb Get-GitBranch

function Get-GitBranchAll {
    git branch -a $args
}
Set-Alias gba Get-GitBranchAll

function Get-GitLogPretty {
    git log --pretty $args
}
Set-Alias glg Get-GitLogPretty

function Get-GitDiff {
    git diff $args
}
Set-Alias gdiff Get-GitDiff

function Get-GitRemote {
    git remote $args
}
Set-Alias gr Get-GitRemote

function Get-GitReset {
    git reset $args
}
Set-Alias gre Get-GitReset


# More complex aliases as functions

# Alias for git commit amend
function gca {
    git add --all
    git commit --amend --no-edit
}

# Alias for git log with graphical format
function gitlog {
    git log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all
}

# Alias for git log (last commit)
function glast {
    git log -1 HEAD --stat
}

# Alias for git log (more detailed graphical format)
function glog {
    git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit
}
