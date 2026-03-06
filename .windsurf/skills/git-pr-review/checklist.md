# PR Review Checklist

Use this as a reference when reviewing changes. Not every item applies to every PR — skip sections that aren't relevant.

## Correctness
- [ ] Logic handles edge cases (empty inputs, nulls, boundaries)
- [ ] Error paths are handled gracefully
- [ ] No off-by-one errors in loops or slicing
- [ ] Async code awaits properly, no unhandled promises
- [ ] State mutations are intentional and scoped correctly

## Security
- [ ] No hardcoded secrets, API keys, or passwords
- [ ] User inputs are validated and sanitized
- [ ] SQL/NoSQL queries use parameterized inputs
- [ ] File uploads are restricted by type and size
- [ ] Auth checks are present on protected routes
- [ ] No sensitive data logged or exposed in error messages

## Performance
- [ ] No unnecessary re-renders or recomputations
- [ ] Database queries are efficient (no N+1, proper indexes)
- [ ] Large data sets are paginated or streamed
- [ ] No blocking calls in async/event-loop contexts
- [ ] Assets are appropriately sized and cached

## Testing
- [ ] New behavior has test coverage
- [ ] Existing tests were not weakened or deleted without reason
- [ ] Edge cases are tested (empty, null, max, min, error)
- [ ] Tests are deterministic (no flaky timing dependencies)

## Code Quality
- [ ] Functions are focused and reasonably sized
- [ ] Names are clear and descriptive
- [ ] No dead code or commented-out blocks
- [ ] DRY — no copy-pasted logic that should be extracted
- [ ] Error messages are helpful for debugging

## Style & Consistency
- [ ] Follows existing project conventions
- [ ] Consistent naming (camelCase, snake_case, etc.)
- [ ] Imports are organized
- [ ] No unrelated formatting changes mixed in

## Documentation
- [ ] Public APIs and complex logic have comments where needed
- [ ] README updated if behavior or setup changed
- [ ] Breaking changes are called out
