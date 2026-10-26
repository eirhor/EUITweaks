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
                local order = { "default", "raid", "ready" }
                local libstub = _G.LibStub
                local lsm = libstub and libstub("LibSharedMedia-3.0", true)
                if lsm then
                    local registered = {}
                    for _, name in ipairs(lsm:List("sound") or {}) do
                        if name:sub(1, 6) == "GVM - " then
                            registered[#registered + 1] = name
                        end
                    end
                    table.sort(registered)
                    for _, name in ipairs(registered) do
                        choices[name] = name
                        order[#order + 1] = name
                    end
                end
                order[#order + 1] = "custom"
                local selected = DB().soundChoice
                if selected and not choices[selected] then
                    choices[selected] = selected .. " (unavailable)"
                    order[#order + 1] = selected
                end
                _, h = W:Dropdown(parent, "Sound", y, choices,
                    function() return DB().soundChoice or "default" end,
                    function(v) DB().soundChoice = v end,
                    order); y = y - h
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
