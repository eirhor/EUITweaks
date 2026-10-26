-- EllesmereUI public plugin API (v1); does not patch EllesmereUI internals.
local ID = "EllesmereBloodlustVoice"
local function DB()
    EllesmereBloodlustVoiceDB = EllesmereBloodlustVoiceDB or {}
    return EllesmereBloodlustVoiceDB
end
local function Register()
    local eui = _G.EllesmereUI
    if not (eui and eui.RegisterPlugin) then return end
    eui.RegisterPlugin(ID, {
        label = "Bloodlust Voice",
        modules = {{
            key = "Sounds", title = "Bloodlust Voice",
            description = "Play a voice alert when your Bloodlust lockout expires.",
            pages = { "Sound" },
            buildPage = function(_, parent, yOffset)
                local W = eui.Widgets
                local y, h = yOffset, 0
                _, h = W:SectionHeader(parent, "BLOODLUST READY ALERT", y); y = y - h
                _, h = W:Toggle(parent, "Enable ready sound", y,
                    function() return DB().enabled ~= false end,
                    function(v) DB().enabled = v end); y = y - h
                local choices = {
                    default = "Bloodlust ready (GenericVoiceMedia)",
                    raid = "Raid warning (Blizzard)",
                    ready = "Ready check (Blizzard)",
                    custom = "Custom path (/blvoice path)",
                }
                _, h = W:Dropdown(parent, "Sound", y, choices,
                    function() return DB().soundChoice or "default" end,
                    function(v) DB().soundChoice = v end,
                    { "default", "raid", "ready", "custom" }); y = y - h
                _, h = W:Button(parent, "Test sound", y, function()
                    if _G.EllesmereBloodlustVoice_Play then _G.EllesmereBloodlustVoice_Play(true) end
                end); y = y - h
                return math.abs(y)
            end,
            onReset = function()
                local db = DB()
                db.enabled, db.soundChoice, db.sound = true, "default", nil
            end,
        }},
    })
end
Register()
