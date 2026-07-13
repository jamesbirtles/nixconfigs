## Coding style

- Prefer an array of records over an object map for small lookup tables, so the collection stays a single ordered source of truth (derive any "valid values" list from it rather than hardcoding it separately).
- Keep core logic in pure functions that take their inputs as parameters. Isolate side effects (reading `process`/`env`/the clock, I/O) in a thin wrapper that reads the value and delegates to the pure function — the logic stays testable without stubbing globals.

## Ad-hoc environments

When devenv.nix doesn't exist and a command/tool is missing, create ad-hoc environment:

    $ devenv -O languages.rust.enable:bool true -O packages:pkgs "mypackage mypackage2" shell -- cli args

When the setup is becomes complex create `devenv.nix` and run commands within:

    $ devenv shell -- cli args

See https://devenv.sh/ad-hoc-developer-environments/
