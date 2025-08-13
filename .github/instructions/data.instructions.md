---
applyTo: ".data/**"
---

# `.data/` Generated Data Artifacts Guide (DO NOT EDIT)

## 1. Purpose

Stores intermediate & derived machine-readable data (JSON, XML, embeddings, classification outputs) produced by automation.

## 2. Ownership

PowerShell automation scripts; not hand-authored.

## 3. Typical Contents

- Classification intermediate results
- Embedding repositories & related cache JSON
- Batch OpenAI outputs / processed artifacts
- Economic or external API snapshot data

## 4. Safe Usage

- Read for diagnostics.
- Feed into further automated steps.

## 5. Prohibited Actions

- Manual editing to "fix" results (regenerate instead).
- Deleting large subsets without plan (may force expensive recomputation).

## 6. Regeneration Workflow

1. Adjust original source (content or script).
2. Run minimal necessary script (avoid full rebuild unless required).
3. Verify new artifacts (diff / spot-check).

## 7. Cleanup Strategy

Add cleanup logic to scripts rather than manual pruning. Avoid accumulating stale formats by updating generation scripts.

## 8. Principles

- Ephemeral & reproducible.
- Replace, don’t edit.
- Minimize churn (scope runs carefully).
