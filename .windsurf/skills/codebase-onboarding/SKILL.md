---
name: codebase-onboarding
description: Auto-generate a project overview and onboarding guide by analyzing the repo structure, dependencies, and key files
---

# Codebase Onboarding Skill

Use this skill when the user is new to a codebase, asks "what does this project do?", wants an architecture overview, or needs help understanding how a repo is organized.

## Steps

### 1. Run the structure analysis script

Get a statistical overview of the project:
```bash
bash .windsurf/skills/codebase-onboarding/analyze-structure.sh
```

This produces a summary of file types, directory structure, dependencies, and framework detection.

### 2. Read key project files

Read these files (if they exist) for deeper context:
- `README.md` or `README`
- `package.json`, `requirements.txt`, `Pipfile`, `Cargo.toml`, `go.mod`, `pom.xml`, `build.gradle` — dependency manifests
- `Dockerfile`, `docker-compose.yml` — deployment setup
- `.env.example` or `.env.sample` — environment variables
- Config files (e.g., `tsconfig.json`, `webpack.config.js`, `.eslintrc`)

### 3. Identify architecture

Based on the analysis, determine:
- **Language(s) and framework(s)** — What's the tech stack?
- **Entry points** — Where does execution start? (e.g., `app.py`, `index.js`, `main.go`)
- **Directory layout** — What does each top-level directory contain?
- **Data flow** — How do requests flow through the system? (frontend → backend → database)
- **External dependencies** — APIs, databases, third-party services

### 4. Generate the onboarding guide

Present findings using this structure:

```
## Project Overview: `<project-name>`

### What It Does
<1-3 sentence summary>

### Tech Stack
- **Language**: ...
- **Framework**: ...
- **Database**: ...
- **Other**: ...

### Project Structure
<directory tree with descriptions>

### Key Files
<list of important files and what they do>

### How to Run
<setup and run instructions extracted from README or inferred from config>

### Architecture Notes
<data flow, key patterns, anything non-obvious>
```

### 5. Answer onboarding questions

Refer to [questions.md](questions.md) for common onboarding questions to proactively address. Ask the user if they have specific questions about the codebase after presenting the overview.
