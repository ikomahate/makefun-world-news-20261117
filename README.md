[![make.fun · news-image-20261117](https://make.fun/badge/news-image-20261117.svg)](https://make.fun/bounty/news-image-20261117?utm_source=github&utm_medium=readme&utm_campaign=news-image-20261117)
[![rank](https://make.fun/badge/news-image-20261117/ikomahate/makefun-world-news-20261117/rank.svg)](https://make.fun/bounty/news-image-20261117/leaderboard?utm_source=github&utm_medium=readme&utm_campaign=news-image-20261117)
[![reward](https://make.fun/badge/news-image-20261117/ikomahate/makefun-world-news-20261117/reward.svg)](https://make.fun/bounty/news-image-20261117?utm_source=github&utm_medium=readme&utm_campaign=news-image-20261117)

# The World in One Day â€” 17 November 2026

[![Make.fun competition](https://make.fun/badge/news-image-20261117.svg)](https://make.fun/c/news-image-20261117)
[![Rank](https://make.fun/badge/news-image-20261117/ikomahate/world-news-20261117/rank.svg)](https://make.fun/c/news-image-20261117)
[![Reward](https://make.fun/badge/news-image-20261117/ikomahate/world-news-20261117/reward.svg)](https://make.fun/c/news-image-20261117)

An original illustrated news front page for the free Make.fun competition
`news-image-20261117`. Five verified stories span war, trade, humanitarian
conditions, human rights, and climate negotiations. See [RESEARCH.md](RESEARCH.md)
for reporting dates, source URLs, and access limitations.

![17 November 2026 world news infographic](entry.png)

## Run the entry

Node.js 22.23.5 was used locally. Node 22 built-in modules only; no package
installation, network, fonts, or rendering tools are required at execution.
The committed image is the only artwork asset and the program writes one file.

```powershell
$env:MAKEFUN_OUTPUT_DIR = Join-Path $PWD 'out'
node .\main.ts
```

When `MAKEFUN_OUTPUT_DIR` is unset, the destination is `/output/entry.png`.
The asset path resolves relative to the entrypoint, regardless of the current
working directory. The program checks its pinned SHA-256, PNG signature,
dimensions and size before copying it. `main.ts` was written and then
substantively revised twice in separate assistant editing steps in the genuine
recorded session.

## Validate and rebuild

```powershell
node .\verify.mjs
powershell -NoProfile -ExecutionPolicy Bypass -File .\render.ps1
```

`verify.mjs` launches two independent Node processes in separate working/output
directories, compares all bytes and SHA-256 hashes, checks that only `entry.png`
was written, verifies every PNG chunk checksum and its end marker, and inflates
the image data to validate its size and row filters. Results are written to
`.local/image-validation.json`. Use a fresh workspace or empty `.local/run-a`
and `.local/run-b` if unrelated files were manually placed in those folders.

Rebuilding the artwork uses Windows PowerShell, built-in .NET System.Drawing,
and installed Arial/Georgia fonts. These fonts are used locally and are not
redistributed. Geometry and editorial composition were drawn from scratch.
No photograph, starter artwork, stock illustration or generated AI bitmap is
included. Runtime determinism depends only on the frozen `entry.png` bytes;
cross-platform font rasterisation is not part of entry execution. If rebuilding
changes the image bytes, review the result and update `expectedHash` in `main.ts`.

## Genuine transcripts and official checks

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\bundle-transcripts.ps1
$kit = Join-Path (Split-Path $PWD -Parent) 'kit\news-image-20261117-kit'
node "$kit\cli\makefun.mjs" check --kit "$kit" --repo . --transcripts .\transcripts\entry-transcripts.tar.gz
```

The bundle contains the original Codex JSONL log, processed only by the official
bundler's automatic redaction, plus its manifest/run record. No transcript is
fabricated, rewritten, truncated, or reconstructed. Rebundle after all work is
finished to include the final edits. `-SessionPath` accepts the real log if
automatic discovery cannot find it. Transcripts are ignored by Git and supplied
separately with submission. The original logs remain in Codex's session store.

The run record declares the actual later user mission and explains that the
conversation began with an unresolved placeholder. Harness version, model,
and effort come from genuine metadata. The recorded system setup stays in the
session; separate instruction files are declared withheld. The built-in
`codex_apps` MCP server is listed. This build used no subagents.

Local intake checks are distinct from the sealed image gate and AI judge,
which the kit says run only on Make.fun. See [VALIDATION.md](VALIDATION.md)
for observed results and [PUBLICATION.md](PUBLICATION.md) for remaining steps.

## License

MIT, including the original artwork. Source material is cited for facts only;
third-party articles and photographs are not redistributed. Intended repository:
`ikomahate/world-news-20261117`. Publication and submission require the user's
explicit approval. Neither has been performed.

