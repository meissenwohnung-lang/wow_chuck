local ADDON, ns = ...

-- Kleine Konfigurationsoberfläche + Minimap-Symbol (ohne externe Bibliotheken).
-- Schlägt der Aufbau fehl, bleiben die /chuck-Befehle voll nutzbar.

local OPTIONS = {
    -- { Schlüssel in ChuckNorrisDB, Text }
    { "events", "Sprüche bei Ereignissen (Epic, Boss, Quest, ...)" },
    { "login", "Fakt beim Einloggen" },
    { "death", "Spruch beim Tod (nur für dich)" },
    { "levelup", "Spruch beim Levelaufstieg" },
    { "pdeath", "Todes-Spruch in den Gruppenchat (/p, /i, /raid)" },
    { "gboss", "Boss-Sieg und Wipe in den Gruppenchat" },
}

local atan2 = math.atan2 or math.atan
local panel, button
local checks = {}

local function Print(text) print("|cffffd24dChuck Norris|r: " .. text) end

---------------------------------------------------------------------------
-- Minimap-Symbol
---------------------------------------------------------------------------
local function PlaceButton()
    if not button then return end
    local m = ChuckNorrisDB.minimap
    local rad = math.rad(m.angle or 225)
    button:ClearAllPoints()
    button:SetPoint("CENTER", Minimap, "CENTER", math.cos(rad) * 80, math.sin(rad) * 80)
    if m.hide then button:Hide() else button:Show() end
end

local function CreateMinimapButton()
    button = CreateFrame("Button", "ChuckNorrisMinimapButton", Minimap)
    button:SetSize(31, 31)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(8)
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:RegisterForDrag("LeftButton")

    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetSize(20, 20)
    bg:SetPoint("CENTER", 0, 1)
    bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")

    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetSize(18, 18)
    icon:SetPoint("CENTER", 0, 1)
    icon:SetTexture("Interface\\Icons\\Ability_Warrior_PunishingBlow")
    icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetSize(53, 53)
    border:SetPoint("TOPLEFT")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    button:SetScript("OnClick", function(_, btn)
        if btn == "RightButton" then
            if ns.ShowWindow then ns.ShowWindow() end
        else
            ns.Config:Toggle()
        end
    end)
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("Chuck Norris Facts", 1, 0.82, 0.3)
        GameTooltip:AddLine("by Solomon · Designed for Selo^^", 0.8, 0.85, 0.9)
        GameTooltip:AddLine("Linksklick: Einstellungen", 0.5, 1, 0.5)
        GameTooltip:AddLine("Rechtsklick: Fakt-Fenster", 0.5, 1, 0.5)
        GameTooltip:AddLine("Ziehen: Symbol verschieben", 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)

    button:SetScript("OnDragStart", function(self)
        self:SetScript("OnUpdate", function()
            local mx, my = Minimap:GetCenter()
            local px, py = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            ChuckNorrisDB.minimap.angle = math.deg(atan2(py / scale - my, px / scale - mx))
            PlaceButton()
        end)
    end)
    button:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)

    PlaceButton()
end

---------------------------------------------------------------------------
-- Optionsfenster
---------------------------------------------------------------------------
local Config = {}
ns.Config = Config

function Config:Refresh()
    if not panel then return end
    for key, cb in pairs(checks) do cb:SetChecked(ChuckNorrisDB[key] and true or false) end
    if checks.minimap then checks.minimap:SetChecked(not ChuckNorrisDB.minimap.hide) end
end

local function CreatePanel()
    local h = 120 + (#OPTIONS + 1) * 26 + 40
    panel = CreateFrame("Frame", "ChuckNorrisConfig", UIParent, "BackdropTemplate")
    panel:SetSize(400, h)
    panel:SetPoint("CENTER")
    panel:SetFrameStrata("DIALOG")
    panel:SetClampedToScreen(true)
    panel:SetMovable(true)
    panel:EnableMouse(true)
    panel:RegisterForDrag("LeftButton")
    panel:SetScript("OnDragStart", panel.StartMoving)
    panel:SetScript("OnDragStop", panel.StopMovingOrSizing)
    panel:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
    panel:SetBackdropColor(0.04, 0.05, 0.07, 0.95)
    panel:SetBackdropBorderColor(0.85, 0.70, 0.35, 1)

    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 14, -12)
    title:SetText("Chuck Norris Facts")
    local by = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    by:SetPoint("TOPLEFT", 14, -34)
    by:SetText("by Solomon · Designed for Selo^^")

    local close = CreateFrame("Button", nil, panel, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", 2, 2)

    local y = -60
    local function Check(key, text, onClick)
        local cb = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
        cb:SetSize(26, 26)
        cb:SetPoint("TOPLEFT", 12, y)
        y = y - 26
        local fs = cb:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        fs:SetPoint("LEFT", cb, "RIGHT", 4, 0)
        fs:SetText(text)
        cb:SetScript("OnClick", function(self) onClick(self:GetChecked() and true or false) end)
        checks[key] = cb
    end
    for _, o in ipairs(OPTIONS) do
        Check(o[1], o[2], function(v) ChuckNorrisDB[o[1]] = v end)
    end
    Check("minimap", "Minimap-Symbol anzeigen", function(v)
        ChuckNorrisDB.minimap.hide = not v
        PlaceButton()
    end)

    local b1 = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    b1:SetSize(150, 24)
    b1:SetPoint("TOPLEFT", 14, y - 12)
    b1:SetText("Fakt-Fenster")
    b1:SetScript("OnClick", function() if ns.ShowWindow then ns.ShowWindow() end end)

    local b2 = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    b2:SetSize(150, 24)
    b2:SetPoint("LEFT", b1, "RIGHT", 10, 0)
    b2:SetText("Spruch im Chat")
    b2:SetScript("OnClick", function() Print(ns.NextFact()) end)

    panel:SetScript("OnShow", function() Config:Refresh() end)
    panel:Hide()
    if UISpecialFrames then table.insert(UISpecialFrames, "ChuckNorrisConfig") end
end

function Config:Toggle()
    if not panel then
        Print("Einstellungen nicht verfügbar. /chuck help zeigt alle Befehle.")
        return
    end
    if panel:IsShown() then panel:Hide() else panel:Show() end
end

function Config:Create()
    local ok = pcall(function()
        ChuckNorrisDB.minimap = ChuckNorrisDB.minimap or {}
        if ChuckNorrisDB.minimap.angle == nil then ChuckNorrisDB.minimap.angle = 225 end
        if ChuckNorrisDB.minimap.hide == nil then ChuckNorrisDB.minimap.hide = false end
        CreatePanel()
        CreateMinimapButton()
    end)
    if not ok then Print("Einstellungsfenster konnte nicht aufgebaut werden.") end
end

function Config:ToggleMinimap()
    ChuckNorrisDB.minimap.hide = not ChuckNorrisDB.minimap.hide
    PlaceButton()
    Config:Refresh()
end
