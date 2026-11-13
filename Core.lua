local ADDON, ns = ...

local PREFIX = "|cffffd24dChuck Norris|r: "
local defaults = { login = true, death = true, levelup = true, pdeath = true, events = true, gboss = false, last = 0, point = { "CENTER", "UIParent", "CENTER", 0, -120 } }

local function Pick(list, avoid)
    local n = #list
    if n == 0 then return "" end
    local i = math.random(n)
    if n > 1 and i == avoid then i = i % n + 1 end
    return list[i], i
end

local function NextFact()
    local text, i = Pick(ns.FACTS, ChuckNorrisDB and ChuckNorrisDB.last)
    if ChuckNorrisDB then ChuckNorrisDB.last = i end
    return text
end

local lastDeathChat = 0
function ns.DeathChat()
    if not IsInGroup() then return end
    local now = GetTime()
    if now - lastDeathChat < 30 then return end -- nicht öfter als alle 30 s
    lastDeathChat = now
    local channel = "PARTY"
    if LE_PARTY_CATEGORY_INSTANCE and IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        channel = "INSTANCE_CHAT"
    elseif IsInRaid() then
        channel = "RAID"
    end
    pcall(SendChatMessage, (Pick(ns.DEATH_CHAT)), channel)
end

local function Say(text) print(PREFIX .. text) end

-- Ereignis-Spruch lokal anzeigen (je Ereignis höchstens alle 8 s)
local lastEmit = {}
local function Emit(kind)
    if not ChuckNorrisDB or not ChuckNorrisDB.events then return end
    local list = ns.EVENTS[kind]
    if not list then return end
    local now = GetTime()
    if lastEmit[kind] and now - lastEmit[kind] < 8 then return end
    lastEmit[kind] = now
    Say((Pick(list)))
end

local function GroupSend(kind)
    if not ChuckNorrisDB.gboss or not IsInGroup() then return end
    local channel = "PARTY"
    if LE_PARTY_CATEGORY_INSTANCE and IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then channel = "INSTANCE_CHAT"
    elseif IsInRaid() then channel = "RAID" end
    pcall(SendChatMessage, (Pick(ns.EVENTS[kind])), channel)
end

local lastInstance


---------------------------------------------------------------------------
-- kleines Fenster mit "Nächster Fakt"
---------------------------------------------------------------------------
local win
local function CreateWindow()
    win = CreateFrame("Frame", "ChuckNorrisFrame", UIParent, "BackdropTemplate")
    win:SetSize(320, 120)
    win:SetFrameStrata("MEDIUM")
    win:SetClampedToScreen(true)
    win:SetMovable(true)
    win:EnableMouse(true)
    win:RegisterForDrag("LeftButton")
    win:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
    win:SetBackdropColor(0.04, 0.05, 0.07, 0.92)
    win:SetBackdropBorderColor(0.85, 0.70, 0.35, 1)
    win:SetScript("OnDragStart", win.StartMoving)
    win:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local p, _, rp, x, y = self:GetPoint()
        ChuckNorrisDB.point = { p, "UIParent", rp, x, y }
    end)
    local p = ChuckNorrisDB.point
    win:SetPoint(p[1], UIParent, p[3], p[4], p[5])

    win.title = win:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    win.title:SetPoint("TOPLEFT", 10, -8)
    win.title:SetText("Chuck Norris Facts |cff8a95a5by Solomon|r")  -- Eigenname, bleibt in jeder Sprache

    win.text = win:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    win.text:SetPoint("TOPLEFT", 12, -30)
    win.text:SetPoint("TOPRIGHT", -12, -30)
    win.text:SetJustifyH("LEFT")
    win.text:SetJustifyV("TOP")
    win.text:SetHeight(48)

    local close = CreateFrame("Button", nil, win, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", 2, 2)

    local next = CreateFrame("Button", nil, win, "UIPanelButtonTemplate")
    next:SetSize(130, 22)
    next:SetPoint("BOTTOMLEFT", 10, 10)
    win.next = next
    next:SetText(ns.L.NEXT)
    next:SetScript("OnClick", function() win.text:SetText(NextFact()) end)

    local credit = win:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    credit:SetPoint("BOTTOMRIGHT", -10, 14)
    credit:SetText("Designed for Selo^^")
    win:Hide()
end

local function ShowWindow()
    if not win then CreateWindow() end
    win.text:SetText(NextFact())
    win:Show()
end
ns.ShowWindow = ShowWindow
ns.OnLang(function() if win and win.next then win.next:SetText(ns.L.NEXT) end end)
ns.NextFact = NextFact

---------------------------------------------------------------------------
-- Ereignisse
---------------------------------------------------------------------------
local ev = CreateFrame("Frame")
ev:RegisterEvent("ADDON_LOADED")
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("PLAYER_DEAD")
ev:RegisterEvent("PLAYER_LEVEL_UP")
ev:RegisterEvent("READY_CHECK")
ev:RegisterEvent("CHAT_MSG_LOOT")
ev:RegisterEvent("ENCOUNTER_END")
ev:RegisterEvent("QUEST_TURNED_IN")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("PLAYER_ALIVE")
ev:RegisterEvent("PLAYER_UNGHOST")
ev:RegisterEvent("DUEL_REQUESTED")
ev:RegisterEvent("MERCHANT_SHOW")
ev:SetScript("OnEvent", function(_, event, arg1, arg2, arg3, arg4, arg5, _, _, _, _, _, _, arg12)
    if event == "ADDON_LOADED" and arg1 == ADDON then
        ChuckNorrisDB = ChuckNorrisDB or {}
        for k, v in pairs(defaults) do if ChuckNorrisDB[k] == nil then ChuckNorrisDB[k] = v end end
        math.randomseed(time())
        ns.SetLang(ChuckNorrisDB.lang or ns.DefaultLang())
    elseif event == "PLAYER_LOGIN" then
        if ns.Config then ns.Config:Create() end
        if ChuckNorrisDB.login then Say(NextFact()) end
    elseif event == "PLAYER_DEAD" then
        if ChuckNorrisDB.death then Say((Pick(ns.DEATH))) end
        if ChuckNorrisDB.pdeath then ns.DeathChat() end
    elseif event == "PLAYER_LEVEL_UP" then
        if ChuckNorrisDB.levelup then Say((Pick(ns.LEVEL))) end
    elseif event == "READY_CHECK" then
        Emit("READY")
    elseif event == "CHAT_MSG_LOOT" then
        -- nur eigene Beute (arg12 = GUID des Looters), Qualität über die Farbe des Item-Links
        if type(arg1) == "string" and arg12 == UnitGUID("player") then
            if arg1:find("|cffff8000", 1, true) then Emit("LEGENDARY")
            elseif arg1:find("|cffa335ee", 1, true) then Emit("EPIC") end
        end
    elseif event == "ENCOUNTER_END" then
        -- arg5 = success (1 = Sieg, 0 = Wipe)
        if arg5 == 1 then Emit("BOSSKILL"); GroupSend("BOSSKILL_CHAT")
        else Emit("WIPE"); GroupSend("WIPE_CHAT") end
    elseif event == "QUEST_TURNED_IN" then
        Emit("QUEST")
    elseif event == "PLAYER_ENTERING_WORLD" then
        local inInst, itype = IsInInstance()
        local id = inInst and select(8, GetInstanceInfo()) or nil
        if inInst and id ~= lastInstance and not arg1 and not arg2 then
            if itype == "raid" then Emit("RAID") elseif itype == "party" then Emit("DUNGEON") end
        end
        lastInstance = id
    elseif event == "PLAYER_ALIVE" or event == "PLAYER_UNGHOST" then
        if not UnitIsDeadOrGhost("player") then Emit("RESS") end
    elseif event == "DUEL_REQUESTED" then
        Emit("DUEL")
    elseif event == "MERCHANT_SHOW" then
        if CanMerchantRepair and CanMerchantRepair() and GetRepairAllCost and (GetRepairAllCost() or 0) > 0 then
            Emit("REPAIR")
        end
    end
end)

---------------------------------------------------------------------------
-- /chuck
---------------------------------------------------------------------------
local CHANNELS = { say = "SAY", party = "PARTY", p = "PARTY", guild = "GUILD", g = "GUILD", raid = "RAID", r = "RAID" }

SLASH_CHUCKNORRIS1 = "/chuck"
SlashCmdList["CHUCKNORRIS"] = function(msg)
    local cmd, rest = (msg or ""):match("^(%S*)%s*(.-)$")
    cmd = cmd:lower()
    if cmd == "" then
        Say(NextFact())
    elseif cmd == "lang" or cmd == "language" or cmd == "sprache" then
        local l = rest:lower()
        if l == "de" or l == "en" then
            ns.SetLang(l)
            Say(ns.L.LANG_SET)
        else
            Say(ns.L.LANG_USAGE)
        end
    elseif cmd == "config" or cmd == "options" or cmd == "settings" then
        if ns.Config then ns.Config:Toggle() end
    elseif cmd == "minimap" then
        if ns.Config and ns.Config.ToggleMinimap then ns.Config:ToggleMinimap() end
    elseif cmd == "window" or cmd == "fenster" then
        if win and win:IsShown() then win:Hide() else ShowWindow() end
    elseif CHANNELS[cmd] then
        local ok = pcall(SendChatMessage, "Chuck Norris Fact: " .. NextFact(), CHANNELS[cmd])
        if not ok then Say(ns.L.SEND_FAIL) end
    elseif cmd == "pdeath" and rest:lower() == "test" then
        ns.DeathChat()
    elseif cmd == "login" or cmd == "death" or cmd == "levelup" or cmd == "pdeath" or cmd == "events" or cmd == "gboss" then
        ChuckNorrisDB[cmd] = not ChuckNorrisDB[cmd]
        Say(cmd .. ": " .. (ChuckNorrisDB[cmd] and ns.L.ON or ns.L.OFF))
    else
        for n, line in ipairs(ns.L.HELP) do
            if n == 1 then Say(line) else print(line) end
        end
    end
end
