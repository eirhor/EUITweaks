-- Independent listener mirroring EllesmereUIQoL's player Sated detection.
-- EllesmereUIQoL_Bloodlust.lua uses local functions, so there is no stable public
-- transition callback to hook without editing the upstream addon.
local ADDON = ...
local LOCKOUTS = { 57723, 57724, 80354, 95809, 160455, 264689, 390435 }
local SOUND = "Interface\\AddOns\\GenericVoiceMedia\\Media\\Voice\\BloodlustReady.ogg"
local frame = CreateFrame("Frame")
local active = false
local initialized = false
local mutedUntil = 0
local ticker
local lastAnnouncement = 0

local function HasLockout()
    if not C_UnitAuras or not C_UnitAuras.GetPlayerAuraBySpellID then return nil end
    for _, spellID in ipairs(LOCKOUTS) do
        if C_UnitAuras.GetPlayerAuraBySpellID(spellID) then return true end
    end
    return false
end

local function PlayAlert(force)
    local db = EllesmereBloodlustVoiceDB or {}
    if not force and db.enabled == false then return end
    local choice = db.soundChoice or "default"
    if choice == "raid" then
        PlaySound(SOUNDKIT.RAID_WARNING, "Master")
    elseif choice == "ready" then
        PlaySound(SOUNDKIT.READY_CHECK, "Master")
    else
        local path
        if choice:sub(1, 6) == "GVM - " then
            local libstub = _G.LibStub
            local lsm = libstub and libstub("LibSharedMedia-3.0", true)
            path = lsm and lsm:Fetch("sound", choice, true)
            if not path then
                print("|cffffaa00EllesmereBloodlustVoice:|r Sound not registered: " .. choice)
                return
            end
        else
            path = choice == "custom" and db.sound or SOUND
        end
        if not path or not PlaySoundFile(path, "Master") then
            print("|cffffaa00EllesmereBloodlustVoice:|r Missing sound file: " .. tostring(path))
        end
    end
end
_G.EllesmereBloodlustVoice_Play = PlayAlert

local function Check()
    local present = HasLockout()
    if present == nil then return end
    if not initialized then active = present; initialized = true; return end
    if present then
        active = true
        if not ticker then ticker = C_Timer.NewTicker(0.5, Check) end
    elseif active then
        active = false
        if ticker then ticker:Cancel(); ticker = nil end
        if GetTime() >= mutedUntil and GetTime() - lastAnnouncement > 2 then
            lastAnnouncement = GetTime()
            PlayAlert(false)
        end
    elseif ticker then
        ticker:Cancel(); ticker = nil
    end
end

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterUnitEvent("UNIT_AURA", "player")
frame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_LOGIN" then
        EllesmereBloodlustVoiceDB = EllesmereBloodlustVoiceDB or {}
        C_Timer.After(1, Check)
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Zone transfers can temporarily remove the player aura snapshot.
        mutedUntil = GetTime() + 3
        initialized = false
        if ticker then ticker:Cancel(); ticker = nil end
        C_Timer.After(2, Check)
    else
        if GetTime() >= mutedUntil then Check() end
    end
end)

SLASH_ELLESMEREBLV1 = "/blvoice"
SlashCmdList.ELLESMEREBLV = function(msg)
    msg = (msg or ""):match("^%s*(.-)%s*$")
    if msg == "test" then
        PlayAlert(true)
    elseif msg == "config" then
        if EllesmereUI and EllesmereUI.OpenPlugin then EllesmereUI.OpenPlugin("EllesmereBloodlustVoice") end
    elseif msg:sub(1, 5) == "path " then
        EllesmereBloodlustVoiceDB.sound = msg:sub(6)
        EllesmereBloodlustVoiceDB.soundChoice = "custom"
        print("EllesmereBloodlustVoice sound: " .. EllesmereBloodlustVoiceDB.sound)
    elseif msg == "reset" then
        EllesmereBloodlustVoiceDB.sound = nil
        EllesmereBloodlustVoiceDB.soundChoice = "default"
        print("EllesmereBloodlustVoice sound reset")
    else
        print("EllesmereBloodlustVoice: /blvoice config | /blvoice test | /blvoice path Interface\\AddOns\\...\\file.ogg | /blvoice reset")
    end
end
