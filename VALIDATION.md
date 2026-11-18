# Validation record

Built locally on 18 November 2026 for `news-image-20261117` after reading the
official kit's RULES.txt and competition.yaml. Deadline: 19 November, 00:00 UTC.

## Image and execution

- Format: complete PNG, RGBA, 8 bits per channel, no interlacing.
- Dimensions: **1024 x 1024**; limit 1024 x 1024.
- Size: **84,627 bytes**; limit 1,048,576 bytes.
- SHA-256: `307fa23e4e283504024766ab033e870c10ceea396ea3c4fba9771bb50c58bebf`.
- `node verify.mjs`: two separate Node processes and output directories;
  byte-identical outputs, matching the committed artwork asset. The program
  uses only Node 22 built-in modules and contains no network calls.
- All PNG chunks and CRC-32 checksums validated through IEND; the complete
  IDAT stream inflates to the expected rows, with valid row-filter bytes.
- A second invocation of render.ps1 also reproduced the same asset hash.
- Full image and 300 x 300 preview visually inspected: date, all five
  headlines, and story summaries readable. Tiny source/footer details are
  supplementary. Preview: `.local/preview-300.png`.
- Verification machine: Windows, Node **v22.23.5**. No Linux container run was
  performed. The sandbox runtime copies the static image, without fonts,
  System.Drawing or PowerShell.

## Official local checker

The official CLI is the unmodified file from the downloaded kit:
`../kit/news-image-20261117-kit/cli/makefun.mjs`.

Initial worktree check confirmed **99.5% authored coverage (476/478 counted
lines)**, six substantive assistant turns, priced genuine usage, valid
timestamps, the correct run record, and two entrypoint writing messages.
It required an SPDX marker in LICENSE; this was added. Additional authored
work then pinned the image hash and added the local commit handoff. Final
checker results are saved in `.local/check-final.json`. The completed worktree
check at **2026-11-18T09:31:18.256Z** returned **ok: true**, exit code **0**,
with **no failed checks**. It reported **97.6% authored coverage (551/564 counted
lines)**, **8 substantive assistant turns**, and **3 entrypoint writing/editing
messages**. The OSI license and all applicable transcript checks passed. These
counts can increase when the final session is bundled.

The sealed PNG gate and AI judge are server-only. No local competitive score
is available; no entry has been submitted. Repository visibility, account
ownership/linkage, GitHub creation time, pushed commit presence, duplicate
snapshot checks, and the eventual signed transcript commitment are checked
at submission. This build does not claim they have passed.

The official bundler applies its own privacy/credential redaction to copied
logs. Gitleaks is not installed locally; the site also scans with it.
No source session log has been edited or fabricated.

## Git sandbox restriction and exact continuation

Fresh `git init -b main` succeeded. This managed session then denied writes
to `.git/config` and denied `git add` with:

```text
fatal: Unable to create 'C:/Users/fauza/makefun-bounty/news-image-work/world-news-entry/.git/index.lock': Permission denied
```

Therefore no commit SHA is claimed. The image and source files are complete;
Git metadata is read-only under this session's permission profile. Run this
exact command in a normal local PowerShell terminal to verify, stage the named
entry files, create a commit, rebundle the genuine log and check that commit:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File 'C:\Users\fauza\makefun-bounty\news-image-work\world-news-entry\finish-local.ps1'
```

This script does not publish, authenticate, access wallet keys, sign messages,
submit, or make payments. It prints the commit SHA on success. Publication
and submission remain separate actions requiring explicit approval, as
described in PUBLICATION.md. After running it, this dated validation note
remains a record of the original sandbox limitation.
