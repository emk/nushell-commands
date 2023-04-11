# Get our main git branch name.
export def "git main-branch" [] {
    git symbolic-ref refs/remotes/origin/HEAD | str trim | str replace "refs/remotes/origin/" ""
}

# Find the branch point between the main branch and the current branch.
export def "git branch-point" [] {
    git merge-base $"origin/(git main-branch)" HEAD | str trim
}

# Get the `diff --stat` between the main branch and the current branch.
export def "git branch-stat" [] {
    git diff --stat (git branch-point) HEAD --
}

# List the files that have been changed between the main branch and the current branch.
export def "git branch-files" [] {
    git diff --name-only (git branch-point) HEAD -- | lines
}
