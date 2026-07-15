# Working with James

## Model-First Engineering

The single most important thing to understand about how I work is that I am a **model-first engineer**.

I don't naturally think in implementations. I think in systems.

When approaching a problem, my primary goal is to build a coherent mental model of how the system works. Once that model is internally consistent, implementations, APIs and bug fixes tend to follow naturally.

Most of my engineering strengths come from this way of thinking:

- Reading documentation isn't about memorising APIs; it's about building an accurate model of the system.
- Debugging is about finding inconsistencies between reality and my model.
- Architecture discussions are about refining the model, not choosing patterns.
- Code is an expression of the model, not the model itself.

## How I Debug

When debugging, I don't start by looking for a fix.

Instead I ask:

> "Does my current mental model predict this behaviour?"

If the answer is no, then one of two things is true:

1. My mental model is incomplete.
2. My understanding of the observed behaviour is incomplete.

The goal is to resolve that inconsistency.

Once the model explains the behaviour, the implementation usually becomes much more obvious.

## How I Learn

I learn by constructing models.

The fastest way for me to understand a system is to understand:

- responsibilities
- information flow
- ownership
- invariants
- assumptions

Facts, documentation, and code are all valuable because they improve or test the model. Writing code in particular is one of the ways I construct and refine a mental model, not merely the final output of my reasoning.

When an implementation suddenly becomes clear, that usually means the model has become coherent enough for me to execute.

## Working With AI

Do **not** optimise primarily for writing code.

Optimise for improving my understanding.

Good AI interactions help me build a better model before they generate large amounts of code.

A good workflow is:

1. Build a shared understanding of the existing system.
2. Challenge and refine the model.
3. Explain the trade-offs.
4. Generate implementation only once the model is coherent.

Large, fully-implemented solutions before I understand the system tend to overwhelm me because they remove an important part of my reasoning process.

Do not remove all implementation work from me by default. Writing key parts myself may be necessary for me to test, refine, and internalise the model.

When generating code, prefer small, explainable increments that I can relate back to the system model.

## During Design Discussions

When proposing an architecture:

- explain the underlying model
- explain the responsibilities
- explain why each abstraction exists
- explain what problem it solves

Don't jump straight to implementation details.

Help me understand **why** before **how**.

## During Code Review

If we disagree, assume we are working from different mental models.

Help identify:

- which assumptions differ
- which part of my model is incomplete
- what information would reconcile the two models

Avoid framing discussions as simply "this implementation is better."

I'm much more interested in understanding the model that produced the implementation.

## Communication

My natural tendency is to hedge because I dislike being confidently wrong.

Help me present my reasoning clearly rather than apologising for it.

Confidence should come from the quality of the reasoning, not certainty of the conclusion.

## Types, Functional Programming, and Explicit Models

Strong type systems appeal to me because they make the model of a system explicit and enforceable.

Types are not only a way to prevent bugs. They also:

- encode assumptions and invariants
- reduce the number of possible states I need to reason about
- expose ambiguity in the domain
- make relationships between parts of the system visible
- allow the compiler to continuously test parts of the model

I prefer types that accurately represent the domain, especially when they make invalid states difficult or impossible to express.

Functional programming ideas often appeal to me for similar reasons. Making state, effects, transformations, and dependencies explicit reduces hidden behaviour and gives me a clearer model of the system.

However, conceptual elegance is not sufficient on its own. The model must still map usefully onto the realities of the problem and the surrounding codebase.

When helping me design types or APIs:

- start from the domain and its possible states
- identify invariants and impossible combinations
- distinguish data from behaviour and effects
- explain how the proposed types represent the underlying model
- avoid weakening types merely to make an implementation easier
- also challenge types that add conceptual machinery without improving the practical model

---

## Coding style

- Prefer an array of records over an object map for small lookup tables, so the collection stays a single ordered source of truth (derive any "valid values" list from it rather than hardcoding it separately).
- Keep core logic in pure functions that take their inputs as parameters. Isolate side effects (reading `process`/`env`/the clock, I/O) in a thin wrapper that reads the value and delegates to the pure function — the logic stays testable without stubbing globals.

## Ad-hoc environments

When devenv.nix doesn't exist and a command/tool is missing, create ad-hoc environment:

    $ devenv -O languages.rust.enable:bool true -O packages:pkgs "mypackage mypackage2" shell -- cli args

When the setup becomes complex create `devenv.nix` and run commands within:

    $ devenv shell -- cli args

See https://devenv.sh/ad-hoc-developer-environments/
