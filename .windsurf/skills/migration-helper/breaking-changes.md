# Common Breaking Changes Reference

Quick reference for frequently encountered migrations. Search this file for the library you're upgrading.

---

## React 17 → 18

- **New root API**: `ReactDOM.render()` → `ReactDOM.createRoot().render()`
- **Automatic batching**: State updates in timeouts/promises now batch (may change render timing)
- **Strict Mode**: Double-invokes effects in dev mode for resilience testing
- **Removed**: `unstable_changedBits`, `ReactDOM.unmountComponentAtNode()`
- **Deprecated patterns to scan for**:
  ```
  ReactDOM.render
  ReactDOM.unmountComponentAtNode
  ```

## React Class Lifecycle Deprecations (16.3+)

- `componentWillMount` → `componentDidMount` or `useEffect`
- `componentWillReceiveProps` → `getDerivedStateFromProps` or `useEffect`
- `componentWillUpdate` → `getSnapshotBeforeUpdate` + `componentDidUpdate`
- **Scan patterns**: `componentWillMount`, `componentWillReceiveProps`, `componentWillUpdate`

## Express 4 → 5

- **Removed**: `app.del()` (use `app.delete()`)
- **Removed**: `req.param()` (use `req.params`, `req.body`, or `req.query`)
- **Changed**: `res.redirect()` no longer accepts relative URLs by default
- **Changed**: Path route matching is stricter (trailing slashes, param patterns)
- **Scan patterns**: `app.del(`, `req.param(`, `res.redirect('`

## Node.js 16 → 18 → 20

- **18**: `fetch` is globally available (no more `node-fetch` needed for basic use)
- **18**: `--experimental-specifier-resolution` removed
- **20**: Test runner is stable (`node:test`)
- **20**: Permission model added (`--experimental-permission`)
- **Scan patterns**: `require('node-fetch')`, `--experimental-specifier-resolution`

## Jest 28 → 29

- **Changed**: `jest.fn().mockReturnThis()` chainability
- **Removed**: `jest-environment-jsdom` now a separate package
- **Changed**: Snapshot format updated
- **Scan patterns**: `jest-environment-jsdom`

## Python 3.8 → 3.12

- **3.9**: `dict` can be used as type hint directly (no `from typing import Dict`)
- **3.10**: `match`/`case` statements, `X | Y` union types
- **3.11**: Exception groups, `tomllib` in stdlib
- **3.12**: `type` statement for type aliases, f-string improvements
- **Removed in 3.12**: `distutils` (use `setuptools`), `imp` (use `importlib`)
- **Scan patterns**: `from typing import Dict`, `from typing import List`, `import distutils`, `import imp`

## Flask 2 → 3

- **Minimum Python**: 3.8+
- **Removed**: `@app.before_first_request` (use `record_once` on blueprint or app init)
- **Changed**: JSON handling uses stdlib `json` by default
- **Scan patterns**: `before_first_request`, `flask.json.jsonify`

## Django 4 → 5

- **Removed**: `DEFAULT_AUTO_FIELD` must be set explicitly
- **Removed**: `USE_L10N` setting (always True now)
- **Changed**: Form rendering uses div-based layout by default
- **Scan patterns**: `USE_L10N`, `default_auto_field`

## Tailwind CSS 2 → 3

- **JIT is default**: No more `mode: 'jit'`
- **Changed**: Color palette renamed (`warmGray` → `stone`, `trueGray` → `neutral`, etc.)
- **Changed**: `purge` config → `content` config
- **Scan patterns**: `mode: 'jit'`, `purge:`, `warmGray`, `trueGray`, `coolGray`, `blueGray`

---

## Adding New Entries

When researching a migration not listed here, add it following this format:

```markdown
## [Library] [Old Version] → [New Version]

- **Changed**: description
- **Removed**: description
- **Deprecated**: description
- **Scan patterns**: `pattern1`, `pattern2`
```
