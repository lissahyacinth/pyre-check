# Pyre Check
GitHub Action to check Python Repositories against [Pyre](https://github.com/facebook/pyre-check)

## Example Workflow

```
name: Static Analysis against Pyre

on: pull_request

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - name: Set up Python 3.x
      uses: actions/setup-python@v1
      with:
        python-version: '3.x'
    - name: Pyre-Check Action Step
      uses: lissahyacinth/pyre-check-action@v1.1.3
      with:
        token: ${{ secrets.GITHUB_TOKEN }}
        pip: "numpy pandas"
        args: "--source-directory . --search-path /usr/local/lib/python3.8/site-packages"
```

### Sources
Took example of how to use GitHub Actions to comment on PRs from https://github.com/yokawasa/action-sqlcheck.
