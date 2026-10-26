# EllesmereBloodlustVoice

Announces when your own Bloodlust lockout (Sated, Exhaustion, etc.) disappears. Mirrors the debuff list and player-only aura lookup used by EllesmereUIQoL; it does **not** patch EllesmereUI or hook private Lua functions.

## Installation

Copy `EllesmereBloodlustVoice` into `World of Warcraft/_retail_/Interface/AddOns/`. Requires EllesmereUIQoL. For voice playback, install GenericVoiceMedia and provide a matching sound file.

## Sound file

Default expected path:
`Interface\\AddOns\\GenericVoiceMedia\\Media\\Voice\\BloodlustReady.ogg`

**The audio file is not included.** The existing GenericVoiceMedia repository has not been verified to contain this filename. Either add an OGG at that location or point the addon to an existing file:

`/blvoice path Interface\\AddOns\\GenericVoiceMedia\\Media\\Voice\\YOUR_FILE.ogg`

`/blvoice test` tests playback, and `/blvoice reset` restores the default path.

## Notes

- No alert on initial login / UI reload or during the first few seconds of zoning.
- Detection is based on the player debuff, not the Bloodlust ability cooldown.
- Only plays when an observed lockout transitions from present to absent. This includes manual aura removal, if possible.
- Combat aura access may change in future WoW patches; test in-game.

## EllesmereUI settings (v0.2.0)

Open `/eui`, then the **Bloodlust Voice** plugin section, or type `/blvoice config`.
Choose the ready sound, toggle the notification, and test it. Options include the
GenericVoiceMedia `BloodlustReady.ogg` file, Blizzard raid warning and ready check,
or a custom path configured using `/blvoice path Interface\\AddOns\\...\\sound.ogg`.
The plugin uses EllesmereUI's documented `RegisterPlugin` API; it does not patch
EllesmereUI or hook private tracking functions. Custom sounds must exist on disk
before starting WoW (a reload alone may not load newly added sound assets).
