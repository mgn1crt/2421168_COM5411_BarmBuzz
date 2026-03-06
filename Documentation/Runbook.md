# Runbook (Student)

06/03/2026 (Initial commit/Runbook.md)
- Imported student template for git repository (as "Initial commit") from https://github.com/beeteetoo/Student_COM5411_Barmbuzz.
- Removed superfluous information (that being references to items outside of this repository) from this (Runbook.md) file as originally committed as "Initial template commit".
- Noted that procedure to resolve inability to commit was not fully resolved as expected:
1. Initiai failiure to commit caused by apparent non-existence of keys was actually due to syntax error in GPG configuration.
2. git config --global gpg.program "C:/Program Files/GunPG/bin/gpg.exe" was incorrectly entered without a forward-slash after C:.
3. Commit was still subsequently blocked due to email privacy settings; this was resolved through use of the Github specified noreply email address.
4. However, this resulted in a commit of the previous commit of Runbook.md shown as Unverified as the noreply address did not match the commiter email.
5. This should be resolved through adding this additional email address to the key via *gpg --edit-key*.

This is shown in this file /Documentation/Runbook.md and in the history for this file on Github.

Keep a dated log of:
- what you changed
- what you ran (commands)
- where the evidence is stored (paths)
