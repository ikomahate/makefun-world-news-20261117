# Publication and submission handoff

Deadline: **19 November 2026, 00:00 UTC** (07:00 in Bangkok).
Official kit opening: 17 November 2026, 23:43 UTC.

Nothing has been published, submitted, paid, signed or linked by this build.
No private wallet key or credential file was accessed. Git author identity is
local attribution only; it does not authenticate a GitHub account.

## After explicit approval to publish

Verify that GitHub CLI is authenticated as `ikomahate`, and that the intended
repository name is available. The fresh public repository must be created
after the competition opening. These commands are a handoff, not actions run
by the agent:

```powershell
Set-Location 'C:\Users\fauza\makefun-bounty\news-image-work\world-news-entry'
gh auth status
gh repo create ikomahate/world-news-20261117 --public --source . --remote origin --push
gh repo edit ikomahate/world-news-20261117 --homepage 'https://make.fun/c/news-image-20261117' --add-topic makefun
```

The README includes all three required live badges for that exact owner/name.
If a different name is chosen, revise both repository-specific badge URLs and
commit the change before publishing or submitting.

## Account ownership and signing: separate explicit approval required

While signed in to Make.fun as `@hazel-kestrel-73`, confirm that GitHub account
`ikomahate` is linked. If that link is absent, either link it yourself or add
`.makefun/owner.json` containing the public address of a wallet verified as
linked to that account, then commit and push. Do not invent an address. The
official rules say this competition is escrow-funded and requires an entry
message signed by a linked Solana wallet. Account and wallet linkage have not
been verified. No keypair creation, login signing or key access is authorized.

Rebundle and recheck the final commit before approval to submit:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\bundle-transcripts.ps1
$kit = Join-Path (Split-Path $PWD -Parent) 'kit\news-image-20261117-kit'
node "$kit\cli\makefun.mjs" check --kit "$kit" --repo . --transcripts .\transcripts\entry-transcripts.tar.gz
git rev-parse HEAD
```

After explicit approval to sign and submit, the official CLI command has this
form. Set `$approvedWalletPath` yourself outside this repository. It names an
already linked wallet; this document neither creates nor reads it:

```powershell
$entryCommit = git rev-parse HEAD
node "$kit\cli\makefun.mjs" submit --competition news-image-20261117 --repo-url 'https://github.com/ikomahate/world-news-20261117' --commit $entryCommit --title 'The World in One Day' --bundle .\transcripts\entry-transcripts.tar.gz --keypair $approvedWalletPath
```

This command signs an entry message and uploads the entry. Do not run it
without that separate approval. The contest has no entry fee. No payment or
on-chain transaction is part of this build. The rules separately state that
claiming an eventual escrow prize can incur a Solana network fee and account
rent; any such later transaction requires its own explicit approval.
