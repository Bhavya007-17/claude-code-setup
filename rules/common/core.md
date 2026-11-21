# Core Rules

1. Commits: `type: description` (feat|fix|refactor|docs|test|chore|perf|ci). No attribution or `Co-Authored-By` trailer.
2. Before hand-rolling anything non-trivial, check for an existing implementation: `gh search code`, then package registries. Port proven code. Skip the search for small or local changes.
3. Tests before implementation. 80% coverage minimum.
4. Prefer immutable updates — return a new object, don't mutate in place.
