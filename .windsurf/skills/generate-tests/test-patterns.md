# Test Patterns Reference

Adapt test generation to the project's existing conventions. This document covers common patterns across frameworks.

## JavaScript / Jest

### File Naming
- `<module>.test.js` in a `__tests__/` directory (most common)
- `<module>.spec.js` co-located with source files (alternative)

### Structure
```javascript
describe('ModuleName', () => {
  describe('functionName', () => {
    it('describes what the function does in this scenario', () => {
      // Arrange
      const input = { ... };

      // Act
      const result = functionName(input);

      // Assert
      expect(result).toBe(expected);
    });

    it('handles edge case: empty input', () => {
      expect(functionName([])).toEqual([]);
    });

    it('throws on invalid input', () => {
      expect(() => functionName(null)).toThrow();
    });
  });
});
```

### Mocking
```javascript
// Mock a module
jest.mock('../path/to/module', () => ({
  someFunction: jest.fn().mockReturnValue('mocked'),
}));

// Mock a single function
const spy = jest.spyOn(object, 'method').mockImplementation(() => 'mocked');

// Reset between tests
afterEach(() => jest.restoreAllMocks());
```

### Async
```javascript
it('fetches data', async () => {
  const data = await fetchData();
  expect(data).toHaveLength(3);
});
```

---

## Python / pytest

### File Naming
- `test_<module>.py` in a `tests/` directory
- `<module>_test.py` (alternative)

### Structure
```python
class TestClassName:
    def test_basic_behavior(self):
        """Describe what this tests."""
        result = function_under_test(input_value)
        assert result == expected_value

    def test_edge_case_empty_input(self):
        assert function_under_test([]) == []

    def test_raises_on_invalid_input(self):
        with pytest.raises(ValueError):
            function_under_test(None)
```

### Fixtures
```python
@pytest.fixture
def sample_data():
    return {"key": "value", "count": 42}

def test_with_fixture(sample_data):
    result = process(sample_data)
    assert result["count"] == 42
```

### Mocking
```python
from unittest.mock import patch, MagicMock

@patch('module.external_function')
def test_with_mock(mock_fn):
    mock_fn.return_value = 'mocked'
    result = function_that_calls_external()
    assert result == 'mocked'
    mock_fn.assert_called_once()
```

---

## General Principles

1. **Arrange-Act-Assert** — set up data, call the function, check the result
2. **One assertion per concept** — each test should verify one behavior
3. **Descriptive names** — test name should describe the scenario and expected outcome
4. **Independent tests** — no test should depend on another test's side effects
5. **Test boundaries** — empty, null, zero, negative, max, min, off-by-one
6. **Don't test implementation** — test behavior, not internal details
7. **Fast tests** — mock I/O, network, and database calls
