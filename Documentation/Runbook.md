# Runbook (2421168 - Mark Naylor)

## Repository link is: https://github.com/mgn1crt/2421168_COM5411_BarmBuzz

## 06/03/2026 Imported template and updated Runbook.md:
1. Imported student template for git repository (as "Initial commit") from https://github.com/beeteetoo/Student_COM5411_Barmbuzz.

> Evidence: "Initial commit" of 06/03/2026 at 

2. Removed superfluous information (that being references to items outside of this repository) from this (Runbook.md) file.

> Evidence: "Initial template commit" of 06/03/2026.

3. Noted that procedure to resolve inability to commit was not fully resolved as expected:
    1. Initiai failiure to commit caused by apparent non-existence of keys was actually due to syntax error in GPG configuration.
    2. git config --global gpg.program "C:/Program Files/GunPG/bin/gpg.exe" was incorrectly entered without a forward-slash after C:.
    3. Commit was still subsequently blocked due to email privacy settings; this was resolved through use of the Github specified noreply email address.
    4. However, this resulted in a commit of the previous commit of Runbook.md shown as Unverified as the noreply address did not match the commiter email.
    5. This should be resolved through adding this additional email address to the key via *gpg --edit-key*.

> Evidence: "Updated Runbook.md" of 06/03/2026 and this file.

## 17/03/2026 Updated Runbook.md:

1. Applied consistent improved format to Runbook and removed logging guidance from initial template (as of 06/03/2026 /1 above).
2. Provided single prioritised link (at start of document) to repository and removed duplicitous references to this per evidence detail (all commits inherently sit within the repository as specified in that URL).


> Evidence: "Updated Runbook.md" of 17/03/2026 and this file.
