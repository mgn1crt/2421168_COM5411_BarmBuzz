# AI Usage Log (AI_LOG)
# 2421168 - Mark Naylor

## 06/03/2026 0712 GPG issue resolution:
GAI used: OpenAI ChatGPT

Purpose: Ascertain reasoning for commit failiure (Updated Runbook.md of 17/03/2026 at approximate same time).

Summary:
1. An additional secodnary GPG key was created for working from my desktop PC.
2. Key was configured as per git config --global user.signingkey and git config --global commit.gpgsign true commands.
2. Commit failed as GPG failed to sign data, reporting no secret key.

AI response:
1. Suggested either disabling GPG signing or using SSH; these were disregarded as both incompatible with assignment requirements.
2. Subsequently suggewsted checking that git config --global gpg.program was set correctly.
3. Advised that this is a common issue when using VSCode on Windows.

Outcome:
1. Set git config --global gpg.program correctly, to the gpg.exe instance on my desktop.
2. Commit achieved successfully.
