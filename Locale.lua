local ADDON, ns = ...

-- Oberflächentexte (de/en) und Sprachumschaltung.
-- Die Sprüche selbst stehen in Facts.lua (ns.TEXT).

ns.S = {
    de = {
        NAME = "Chuck Norris Facts",
        LANG_NAME = "Deutsch",
        NEXT = "Nächster Fakt",
        WINDOW = "Fakt-Fenster",
        CHAT_QUIP = "Spruch im Chat",
        SEND_FAIL = "Senden nicht möglich.",
        ON = "an", OFF = "aus",
        LANGUAGE = "Sprache",
        LANG_SET = "Sprache: Deutsch",
        LANG_USAGE = "Verwendung: /chuck lang de|en",
        CFG_UNAVAILABLE = "Einstellungen nicht verfügbar. /chuck help zeigt alle Befehle.",
        CFG_FAILED = "Einstellungsfenster konnte nicht aufgebaut werden.",
        MINIMAP_SHOW = "Minimap-Symbol anzeigen",
        TT_LEFT = "Linksklick: Einstellungen",
        TT_RIGHT = "Rechtsklick: Fakt-Fenster",
        TT_DRAG = "Ziehen: Symbol verschieben",
        OPT = {
            events = "Sprüche bei Ereignissen (Epic, Boss, Quest, ...)",
            login = "Fakt beim Einloggen",
            death = "Spruch beim Tod (nur für dich)",
            levelup = "Spruch beim Levelaufstieg",
            pdeath = "Todes-Spruch in den Gruppenchat (/p, /i, /raid)",
            gboss = "Boss-Sieg und Wipe in den Gruppenchat",
        },
        HELP = {
            "Befehle:",
            "/chuck – zufälliger Fakt im Chat-Fenster",
            "/chuck config – Einstellungsfenster (auch per Minimap-Symbol); /chuck minimap – Symbol ein/aus",
            "/chuck lang de|en – Sprache (Deutsch/English)",
            "/chuck window – kleines Fenster mit Knopf 'Nächster Fakt'",
            "/chuck say|party|guild|raid – Fakt an den Chat senden",
            "/chuck pdeath – bei deinem Tod einen Spruch in /p, /i oder /raid senden (ein/aus, max. alle 30 s)",
            "/chuck pdeath test – Spruch jetzt in den Gruppenchat senden",
            "/chuck events – Sprüche bei Ereignissen (Bereitschaftscheck, Epic, Boss, Wipe, Quest, Instanz, Reparatur, Duell) ein/aus",
            "/chuck gboss – Boss-Sieg/Wipe zusätzlich in den Gruppenchat (Standard: aus)",
            "/chuck login|death|levelup – Sprüche bei Login/Tod/Levelaufstieg ein/aus",
            "by Solomon · Designed for Selo^^",
        },
    },
    en = {
        NAME = "Chuck Norris Facts",
        LANG_NAME = "English",
        NEXT = "Next fact",
        WINDOW = "Fact window",
        CHAT_QUIP = "Quip in chat",
        SEND_FAIL = "Could not send.",
        ON = "on", OFF = "off",
        LANGUAGE = "Language",
        LANG_SET = "Language: English",
        LANG_USAGE = "Usage: /chuck lang de|en",
        CFG_UNAVAILABLE = "Settings unavailable. /chuck help lists all commands.",
        CFG_FAILED = "Settings window could not be built.",
        MINIMAP_SHOW = "Show minimap icon",
        TT_LEFT = "Left-click: settings",
        TT_RIGHT = "Right-click: fact window",
        TT_DRAG = "Drag: move icon",
        OPT = {
            events = "Quips on events (epic, boss, quest, ...)",
            login = "Fact on login",
            death = "Quip on death (only for you)",
            levelup = "Quip on level up",
            pdeath = "Death quip in group chat (/p, /i, /raid)",
            gboss = "Boss kill and wipe in group chat",
        },
        HELP = {
            "Commands:",
            "/chuck - random fact in the chat window",
            "/chuck config - settings window (also via minimap icon); /chuck minimap - icon on/off",
            "/chuck lang de|en - language (Deutsch/English)",
            "/chuck window - small window with a 'Next fact' button",
            "/chuck say|party|guild|raid - send a fact to chat",
            "/chuck pdeath - send a quip to /p, /i or /raid when you die (on/off, at most every 30 s)",
            "/chuck pdeath test - send a quip to group chat now",
            "/chuck events - quips on events (ready check, epic, boss, wipe, quest, instance, repair, duel) on/off",
            "/chuck gboss - also post boss kill/wipe to group chat (default: off)",
            "/chuck login|death|levelup - quips on login/death/level up on/off",
            "by Solomon · Designed for Selo^^",
        },
    },
}

local hooks = {}
function ns.OnLang(fn) hooks[#hooks + 1] = fn end

function ns.DefaultLang()
    return (GetLocale and GetLocale() == "deDE") and "de" or "en"
end

function ns.SetLang(lang)
    if lang ~= "de" and lang ~= "en" then lang = ns.DefaultLang() end
    ns.lang = lang
    ns.L = ns.S[lang]
    local t = ns.TEXT[lang]
    ns.FACTS, ns.DEATH, ns.LEVEL, ns.DEATH_CHAT, ns.EVENTS = t.FACTS, t.DEATH, t.LEVEL, t.DEATH_CHAT, t.EVENTS
    if ChuckNorrisDB then ChuckNorrisDB.lang = lang end
    for _, fn in ipairs(hooks) do pcall(fn) end
end

ns.SetLang(ns.DefaultLang())
