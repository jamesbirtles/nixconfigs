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

However, conceptual elegance is not sufficient on its own — the model must still map usefully onto the realities of the problem and the surrounding codebase. Purity is one of these tools, not a goal in itself: I like domain logic (calculations, transformations, decisions) kept pure and effects kept at clear boundaries, but boundary code should sequence its effects directly and readably rather than disguise them as pure data. Don't reach for effect descriptions, command types, dispatcher loops, or a planning/execution split just to make orchestration look pure — that machinery earns its place only when it genuinely improves the model, correctness, testability, or reuse.

When helping me design types or APIs:

- start from the domain and its possible states
- identify invariants and impossible combinations
- distinguish data from behaviour and effects
- explain how the proposed types represent the underlying model
- avoid weakening types merely to make an implementation easier
- also challenge types that add conceptual machinery without improving the practical model

## Making Illegal States Unrepresentable

This is close to the heart of how I like to program, and I want AI-written code to embody it too.

The core idea: use the type system and module boundaries so that incorrect states cannot be constructed in the first place, rather than being guarded against at runtime. If a value exists, its existence should be proof that its invariants hold.

The canonical example is an authenticated user. If `AuthenticatedUser` is an opaque type whose only constructor is `login`, then any function accepting an `AuthenticatedUser` is *guaranteed* an authenticated user — not by a runtime check, but because no other way to obtain the value exists. A whole class of "but what if they aren't actually authenticated?" questions simply stops existing. This is the same instinct as "parse, don't validate": validate once at the boundary, then encode the result in a type that carries the guarantee forward.

Module boundaries are the enforcement mechanism, not the type alone. Export the public API; keep constructors and internal representations private. A type is only a real guarantee if it cannot be forged from outside its module. So:

- Push validation and construction to a single boundary (a smart constructor / parser).
- Make the constructed type opaque, so possession of a value implies its invariant.
- Let downstream code *depend* on that guarantee by taking the type as a parameter, rather than re-checking it.
- Prefer making a bad state unconstructable over documenting or asserting that it shouldn't happen.

Structure modules around data. A module is naturally built around one type (occasionally two) — its constructors, transformations, and queries all live together, and that module becomes the single owner of the type's invariants. This is what makes the boundary meaningful rather than arbitrary: there is one place that can construct the type and one place that could break it, so that is the one place to hide internals and put the smart constructor. Split files by the data they own, not by arbitrary layering.

This is the sharp end of model-first thinking: making impossible states impossible shrinks the space of states I have to reason about, and lets the compiler continuously test the model.

### Errors as Values

Represent expected failures as values, not as exceptions. A function that can fail should say so in its return type — a `Result` / `Either` — and callers handle each outcome explicitly, ideally with exhaustive pattern matching so the compiler tells me when I've missed a case.

Where unrepresentable states remove what *can't* happen, errors-as-values make what *can* happen explicit. Between them, a function's signature tells the whole truth about what it does and how it can fail — no hidden control flow, no invisible throw. Reserve exceptions for genuinely unexpected, unrecoverable conditions; model expected failure in the type.

This one is aspirational, not a rule. It is rarely worth rewriting how an existing project handles errors just to fit one small change through it. Follow the surrounding code's error conventions; reach for errors-as-values when starting something new, or when a change is already large enough that the shift pays for itself.

### Effect TS

Effect encourages exactly this style — branded types, `Schema` for parse-at-the-boundary, errors as typed values in the channel rather than thrown, and services/`Context` for explicit dependencies. Where it is already part of a codebase, use it to its fullest.

But Effect is a large dependency that requires team buy-in. Do not introduce it to a codebase that doesn't already use it just to obtain these patterns. Without Effect, reach the same guarantees with plain language features: opaque/branded types, private constructors, and disciplined module boundaries. The pattern is the goal; Effect is one way to reach it.

---

## Coding style

- Prefer an array of records over an object map for small lookup tables, so the collection stays a single ordered source of truth (derive any "valid values" list from it rather than hardcoding it separately).

## Ad-hoc environments

When devenv.nix doesn't exist and a command/tool is missing, create ad-hoc environment:

    $ devenv -O languages.rust.enable:bool true -O packages:pkgs "mypackage mypackage2" shell -- cli args

When the setup becomes complex create `devenv.nix` and run commands within:

    $ devenv shell -- cli args

See https://devenv.sh/ad-hoc-developer-environments/
