# Global Claude Code Instructions

## Core Development Philosophy

- Prioritize correctness, security, maintainability, and simplicity.
- Understand existing code before modifying it.
- Prefer the smallest change that correctly solves the problem.
- Follow the existing architecture and conventions.
- Do not rewrite or refactor unrelated code.
- Do not introduce unnecessary dependencies.
- Reuse existing components, utilities, services, hooks, and patterns.

## Scope Control

- Only modify files necessary for the requested change.
- Do not perform opportunistic refactoring.
- Do not change unrelated code.
- Preserve existing behavior unless the task explicitly requires changing it.
- Before creating a new component, utility, service, hook, type, or constant, search for an existing equivalent.
- Prefer extending existing functionality over creating duplicate functionality.

## Project Structure

Follow the project's existing architecture and folder conventions.

When creating new files, place them according to their responsibility.

Prefer keeping shared concerns separated:

- Components → components
- Hooks → hooks
- Utilities → utils
- Types → types
- Constants → constants
- Services → services
- Configuration → configuration/config files

Do not create isolated files unnecessarily when an existing appropriate location already exists.

Domain-specific structural rules are defined in the relevant skills.

## Before Making Changes

For non-trivial tasks:

1. Inspect the relevant files.
2. Understand the existing implementation.
3. Identify existing patterns and dependencies.
4. Form a concise implementation plan.
5. Implement the smallest appropriate change.
6. Run relevant verification.
7. Review the resulting diff.
8. Check for security issues.

For trivial changes:

- Do not over-plan.
- Make the smallest appropriate change.
- Perform lightweight verification when appropriate.

## Existing Code

Before implementing something new:

1. Search for existing implementations.
2. Search for reusable components/utilities/services/hooks.
3. Check existing types and constants.
4. Check existing project conventions.
5. Reuse existing functionality when appropriate.

Do not duplicate functionality that already exists.

## Dependencies

Before adding a dependency:

1. Check whether the project already provides the required functionality.
2. Check whether an existing dependency can solve the problem.
3. Consider maintenance and compatibility.
4. Add the dependency only when justified.

Never silently add dependencies.

## Code Quality

- Prefer readable code over clever code.
- Avoid unnecessary abstractions.
- Avoid duplicated logic.
- Keep functions focused.
- Prefer explicit typing.
- Avoid `any` unless genuinely necessary.
- Prefer `unknown` when data is genuinely unknown.
- Do not suppress compiler or linter errors without justification.
- Do not disable security or lint rules simply to make a build pass.

## Security

Treat all external input as untrusted.

Always consider security implications relevant to the change.

Never:

- Hardcode credentials.
- Hardcode API keys.
- Hardcode access tokens.
- Commit secrets.
- Log passwords.
- Log access tokens.
- Expose server-side secrets to client code.
- Trust client-side authorization.
- Assume authentication means authorization.

For protected resources, verify:

1. The user is authenticated.
2. The user is authorized for the specific resource/action.

Domain-specific security rules are defined in the relevant skills.

## Debugging

When debugging:

1. Understand the error.
2. Identify the root cause.
3. Inspect the relevant code/configuration.
4. Make the smallest appropriate fix.
5. Verify the fix.
6. Check for regressions.

Do not randomly modify multiple unrelated areas.

Do not hide errors simply to make the application build or tests pass.

## Verification

After meaningful changes, run the most relevant available verification.

Depending on the change, this may include:

- Type checking
- Linting
- Unit tests
- Component tests
- Integration tests
- E2E tests
- Build
- Framework-specific validation

Prefer targeted verification over unnecessarily running the entire project.

Never claim that a test, build, or command passed unless it was actually executed.

Testing-specific rules are defined in the testing skill.

## Git Safety

- Never automatically commit.
- Never automatically push.
- Never automatically stage changes.
- Never overwrite unrelated uncommitted work.
- Never reset, revert, checkout, restore, or delete user changes without explicit confirmation.
- Never include `Co-Authored-By`.
- Review relevant diffs before reporting completed work.

Detailed Git workflow is defined in the Git skill.

## Communication

When finishing a meaningful task, report:

### Changed

- What was changed.

### Verification

- Commands/tests actually executed.
- Results of those commands.

### Notes

- Important caveats.
- Remaining issues.
- Follow-up work if applicable.

Keep the response concise and relevant.

Never claim work was performed when it was not actually performed.

## SDD

SDD is optional.

Do not automatically create or use an SDD workflow for every task.

Use SDD when the task is sufficiently complex that explicit requirements, acceptance criteria, design decisions, or implementation planning provide meaningful value.

For small or straightforward tasks:

- Do not create unnecessary specifications.
- Do not perform unnecessary planning.
- Implement directly.

When SDD is used:

- Keep the process focused on the requested feature.
- Do not load unrelated domain guidance.
- Avoid duplicating information already present in the project.
- Do not create unnecessary documentation.
- Continue following all global safety and scope rules.

Skills provide domain-specific implementation guidance when relevant.