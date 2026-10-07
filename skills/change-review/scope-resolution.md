# Scope resolution

How a review target becomes a file list, and the traps that fail quietly and leave the scope block claiming a count it never delivered.

## Default branch

Try `refs/remotes/origin/HEAD`, then `gh repo view --json defaultBranchRef` or the session's GitHub tools. If the ref is missing, ask the remote with `git remote set-head origin --auto` rather than guessing. It needs the network and writes only a ref inside `.git`, so it is permitted, and it goes in Verification. With no remote at all, fall back to a local `main` or `master` and state which base you assumed.

## Targets

The accepted targets are `working`, `staged`, `branch`, `pr <n>`, a bare `<ref>` and an explicit `<a>..<b>` or `<a>...<b>` range. Anything else in the invocation is a `<ref>`.

Diff a branch against the merge base, with three dots. Two dots report every commit that landed on the base branch as part of the change.

When the user wrote a range, use the dots they wrote. `<a>..<b>` compares the two endpoints, and `<a>...<b>` compares `merge-base(<a>, <b>)` with `<b>`. Rewriting `release..feature` to three dots drops everything between `release` and the merge base, which is often what was asked for. State the resolved range in the scope block.

`git diff HEAD` reports tracked files only. Any target that includes uncommitted work pairs it with `git ls-files --others --exclude-standard`. Otherwise a newly added view is silently dropped from a scope the report claims to cover in full.

## Pull requests

Fetch the head into a remote-tracking ref, `git fetch origin "pull/<n>/head:refs/remotes/pr/<n>"`, and review it in place. This works for forks, which `origin/<branch>` does not.

Diff against the pull request's own base, never the default branch by assumption. Read it from `gh pr view <n> --json baseRefName,baseRefOid`, and fetch it if it is not local. A pull request into `release/2.0` diffed against `main` picks up every commit between the two.

Read files at the head ref with `git show refs/remotes/pr/<n>:path/to/File.swift`, never the working-tree copy, which is a different revision.

**Citations.** Line numbers from a fetched ref need not match the working tree. Cite against the head ref, and declare that ref and its SHA in the scope block so the numbers resolve.

**Intent.** The title and body of the pull request are the stated intent for **Hold the change to its stated intent**. Add the commit subjects when the body is empty.

## Awkward repository states

Three are worth handling. Everything else fails loudly at `merge-base`, such as unrelated histories or a repository with no commits. Say the base is unresolvable and stop, because a range you cannot name cannot be reviewed.

**Detached HEAD.** Use the merge base against the default branch, and name the SHA rather than a branch in the scope block.

**Shallow clone**, the CI default, where `merge-base` returns nothing. Fetch with `--deepen=50` and retry, then `--deepen=200`, then report the scope as unresolvable. Deepening writes inside `.git` only, so it is permitted, and it goes in Verification.

**Mid-rebase or mid-merge**, the one that does not fail loudly. `git diff` succeeds and returns something that is not the change, so the review looks fine and is wrong. Detect it with `git rev-parse --git-path` against `rebase-merge`, `rebase-apply`, `MERGE_HEAD` and `CHERRY_PICK_HEAD`. Never test `.git/` paths directly, since they are not directories inside a linked worktree. Stop and say the tree is mid-operation.

## Nothing to review

The tree is clean and `HEAD` is not ahead of the merge base. Gather the facts before asking, so the offer is accurate. They are the current branch, the count ahead of the base, the last commit's SHA and subject and any open pull request from `gh pr status`.

`gh pr status` succeeds when no pull request is open, so an empty result is an answer, not an error. It fails without `gh`, without authentication and in a repository with no GitHub remote. Treat any failure as "no pull request found", say so and offer the remaining routes.

## Renames

`git diff` detects renames by default, and `--name-status` reports `R100 old/path new/path`. Lower the threshold with `--find-renames=40%` when a file was moved and edited in one change. Review a rename as a move, not a deletion and an addition, so only the genuine edits are in scope.

## Excluded paths

Exclude these and name what you excluded in the scope block. They are machine-written and carry no interface rules.

| Category | Patterns |
| --- | --- |
| Dependency lockfiles | `Package.resolved`, `Podfile.lock`, `Cartfile.resolved` |
| Dependencies | `Pods/`, `Carthage/`, `.build/`, `SourcePackages/` |
| Build output | `DerivedData/`, `build/`, `*.xcresult`, `*.ipa`, `*.dSYM/`, `*.xcarchive/` |
| User state | `xcuserdata/`, `*.xcuserstate` |
| Project metadata | `project.pbxproj`, `*.xcscheme`, `contents.xcworkspacedata` |
| Snapshots | `__Snapshots__/` |
| Generated sources | `*.generated.swift`, and SwiftGen or R.swift output |
| Binaries and media | `*.png`, `*.jpg`, `*.heic`, `*.pdf`, `*.mov`, `*.mp4`, `*.car` |

Some of these stay readable although they are excluded from the count. Read `project.pbxproj` for a changed deployment target and for `INFOPLIST_KEY_` purpose strings. A font file added or swapped is a `typography` change, and an image added to a view is a `ui` and `accessibility` change. Review the code that references them, not the bytes.

Three kinds of file stay in scope. `*.colorset/Contents.json` holds a color's appearances, `*.xcstrings` and `*.strings` hold the copy, and `Info.plist` holds purpose strings and the Liquid Glass opt-out.

Apply the exclusions as pathspecs, so the file count in the scope block is the reviewed count:

```bash
git diff --name-only "$BASE" <head-ref> -- . \
  ':(glob,exclude)**/Package.resolved' ':(glob,exclude)**/Pods/**' \
  ':(glob,exclude)**/xcuserdata/**' ':(glob,exclude)**/project.pbxproj' \
  ':(glob,exclude)**/__Snapshots__/**'
```

Give every pattern `glob` magic. Without it, `**/Package.resolved` needs a literal `/` before the name, so it misses the file at the repository root. Run the diff with and without the pathspecs, and confirm the count dropped by exactly the files you named.

## Expanding to consumers

Swift has no imports within a module to follow, so search names. `git grep` searches the working tree by default, so pass the reviewed ref after the pattern. Results come back as `<rev>:path/to/File.swift`, and you read them with `git show`.

```bash
git grep -w -n "PrimaryButtonStyle" <head-ref> -- '*.swift'
```

A changed view or style is found by its type name, and a modifier extension by its method name. A changed color set is found by the symbol Xcode generates for it, such as `.brandAccent`, and by its string name in `Color("BrandAccent")` and `UIColor(named:)`. Pass `-e` when a pattern starts with a dash.

Order the consumers by a rule you can evaluate, so the cutoff is reproducible:

1. **Screens first.** The tabs, navigation roots, destinations and sheets the app's scenes present, since everything else appears inside one. A `#Preview` is not a screen.
2. **Then by reference count**, since a view used in twenty places carries more of the change than one used in two.
3. **Ties by proximity**, the same module or feature folder first.

Say plainly where the order became arbitrary.

## Rendering another revision

Render only when the user asks and Xcode is available. For a target other than the checkout, build an isolated worktree with its own derived data, so the author's build products stay untouched:

```bash
git worktree add /tmp/review-482 refs/remotes/pr/482
xcodebuild -project /tmp/review-482/App.xcodeproj -scheme App \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /tmp/review-482/DerivedData build
git worktree remove /tmp/review-482
```

A project in a workspace takes `-workspace` in place of `-project`. A full build is slow, so name the build time in Verification.
