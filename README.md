# EUI Tweaks

A modular collection of quality-of-life tweaks for EllesmereUI. Each new tweak can have its own settings module/tab inside the **EUI Tweaks** plugin.

## Installation

Install this repository as the addon folder `EUITweaks` under `World of Warcraft/_retail_/Interface/AddOns/`. The addon entrypoint is `EUITweaks.toc`. Requires `EllesmereUIQoL`; `GenericVoiceMedia` is optional for voice sounds.

**Upgrading from EllesmereBloodlustVoice:** Disable or remove the old `EllesmereBloodlustVoice` addon folder to prevent duplicate Bloodlust announcements. The previous `EllesmereBloodlustVoiceDB` SavedVariables table is retained, so existing settings can be reused.

## Settings

Open `/eui` → **EUI Tweaks** → **Bloodlust**. The `/blvoice config` shortcut also opens EUI Tweaks.

## Bloodlust tab

Plays a sound when the player's Bloodlust lockout debuff (Sated, Exhaustion, etc.) disappears, rather than when the Bloodlust spell cooldown ends. The addon tracks the player independently of EllesmereUI's private tracker functions.

Options:
- Enable or disable the notification
- Select from all registered `GVM - ` LibSharedMedia sounds, automatically discovered when opening the settings page
- Choose Blizzard raid warning / ready check or a custom sound path
- Test the selected sound

Commands: `/blvoice test`, `/blvoice config`, `/blvoice path <path>`, `/blvoice reset`.

## Future tweaks

New features should be added as separate modules in the EUI Tweaks plugin. Bloodlust is the first module.

## Notes

The default legacy file path is `Interface\\AddOns\\GenericVoiceMedia\\Media\\Voice\\BloodlustReady.ogg`; selecting the registered `GVM - Bloodlust Ready` entry is recommended when available.

This code has not yet been tested in-game after the rename.
