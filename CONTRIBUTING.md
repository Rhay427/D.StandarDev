# Contributing

This is a personal Claude Code setup shared as-is. It is opinionated on purpose, so the bar for
changes is different from a general-purpose project: **fixes and portability improvements are
welcome, taste changes usually are not.**

If your stack differs from mine, fork it. That is the intended use.

## What lands easily

- Bugs in `install.sh` — wrong path, broken flag, a shell that is not zsh/bash on macOS, a plugin
  name that has since changed.
- Broken or outdated references in the docs: dead links, renamed plugins, a skill that points at a
  file that moved.
- Clarity fixes in `claude/CLAUDE.md` or the skills where the current wording is genuinely
  ambiguous to a model.

## What probably will not land

- New skills, or new plugins in the default set. The set is small because I use every item in it
  daily. Open an issue first and say what it replaces.
- Rewrites of the global rules, or loosening the fast-path gate at the top of each skill. That gate
  is the whole point of the repo — the win is in what Claude decides *not* to do.
- Style-only reformatting of Markdown.

## Making a change

1. Open an issue first for anything that is not an obvious bug. It saves you writing a PR I close.
2. One concern per pull request. A PR that fixes the installer *and* rewords a skill gets split.
3. Test `install.sh` on a real machine before submitting — it writes to `~/.claude` and installs
   plugins, so a broken change costs whoever runs it an afternoon. Say in the PR what you ran it on
   (OS, shell) and whether it was a fresh install or `UPDATE=1`.
4. Skill edits: keep the existing structure. Every skill opens with the fast-path gate before any
   other guidance, and that ordering is load-bearing.

## Plugins

No plugin source is vendored here — `install.sh` fetches each from its own marketplace. Bugs in a
plugin belong in that plugin's repository, not this one. Issues here should be about the *selection*
or the *install flow*.

## License

Contributions are accepted under the [MIT license](LICENSE) that covers this repository.
