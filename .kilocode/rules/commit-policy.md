# 📝 Commit Policy Rules

- Use **Conventional Commits**:
  - `feat:`, `fix:`, `test:`, `chore:`, `docs:`, `refactor:`
- Each commit must:
  - Compile and pass tests independently.
  - Represent one atomic logical change.
- No mixed code + doc + test changes in one commit.
- Commit message format: `<type>(<scope>): <message>`
- Example:
  - `feat(auth): add JWT validation middleware`
