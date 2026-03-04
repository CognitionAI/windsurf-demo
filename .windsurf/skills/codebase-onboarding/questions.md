# Common Onboarding Questions

Proactively address these when generating an onboarding guide. Not all will apply to every project.

## Setup & Running
- How do I install dependencies?
- How do I run the project locally?
- Are there environment variables I need to set?
- Is there a database I need to set up?
- Are there any system-level prerequisites (e.g., specific Node/Python version)?

## Architecture
- What's the high-level architecture? (monolith, microservices, serverless, etc.)
- How is the codebase organized? What does each directory do?
- Where does a request enter the system and how does it flow?
- What are the main data models / entities?
- Are there background jobs, queues, or scheduled tasks?

## Development
- What's the branching strategy? (trunk-based, gitflow, etc.)
- How do I run tests?
- Is there a linter or formatter I should use?
- Are there pre-commit hooks?
- How do I add a new feature end-to-end?

## Deployment
- How is the app deployed? (CI/CD pipeline, manual, etc.)
- What environments exist? (dev, staging, prod)
- How do I access logs?
- How are secrets / config managed in production?

## Conventions
- What naming conventions are used? (files, variables, CSS classes)
- How are errors handled?
- How is state managed? (frontend state, backend sessions, etc.)
- Are there established patterns for common tasks? (API calls, DB queries, etc.)
