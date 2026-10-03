# NamTweaks

Simple, reversible Fortnite configuration tweaks with a one-click Windows launcher.

## Quick start
1. Download/clone this repository.
2. Double-click `Start-NamTweaks.bat`.
3. The script creates a backup in `%USERPROFILE%\NamTweaks-Backup` before changing the Fortnite config.
4. For the performance preset, run PowerShell with `-Preset Performance`.
5. To restore the backup, run `powershell -File scripts\NamTweaks.ps1 -Preset Restore`.

### Presets
- `Balanced` — disables VSync.
- `Performance` — disables VSync and removes the configured FPS cap.
- `Restore` — restores the last NamTweaks backup.

If Fortnite has never been launched on the PC, run it once first so its config directory exists.

This is an independently written tweak pack. It does not include cheats, anti-cheat bypasses, or game exploits.
