# Chuck Norris Facts

Zufällige Chuck-Norris-Sprüche für WoW Forever (Interface 16001) – beim Login, Tod, Levelaufstieg und bei Ereignissen wie Bereitschaftscheck, Epic-Beute, Boss-Sieg, Wipe, Quest, Instanz, Reparatur und Duell.

**by Solomon · Designed for Selo^^**

## Installation

Den Ordner `ChuckNorrisFacts` (Inhalt dieses Repos) nach `World of Warcraft\_retail_\Interface\AddOns\` kopieren. Der Ordnername muss `ChuckNorrisFacts` lauten.

## Befehle

- `/chuck` – zufälliger Fakt im Chat
- `/chuck config` – Einstellungsfenster (auch per Minimap-Symbol); `/chuck minimap` – Symbol ein/aus
- `/chuck window` – kleines Fenster mit „Nächster Fakt“
- `/chuck say|party|guild|raid` – Fakt an den Chat senden
- `/chuck pdeath` – bei deinem Tod einen Spruch in `/p`, `/i` oder `/raid` senden (`/chuck pdeath test` zum Ausprobieren)
- `/chuck events` – Ereignis-Sprüche ein/aus; `/chuck gboss` – Boss-Sieg/Wipe auch in den Gruppenchat
- `/chuck login|death|levelup` – jeweilige Sprüche ein/aus

Neue Sprüche stehen in `Facts.lua` (`ns.FACTS`, `ns.EVENTS`, `ns.DEATH_CHAT`).

## Veröffentlichung (CurseForge / GitHub)

1. Projekt auf CurseForge anlegen, die Projekt-ID in `ChuckNorrisFacts.toc` eintragen: `## X-Curse-Project-ID: 123456`.
2. API-Token von CurseForge als Repo-Secret `CF_API_KEY` hinterlegen.
3. Tag setzen und pushen: `git tag v0.4.0 && git push origin v0.4.0`. Der Workflow packt das Addon (BigWigs-Packager) und lädt es hoch.

Ohne Projekt-ID/Secret erzeugt der Workflow nur den GitHub Release.

## Lizenz

MIT, siehe `LICENSE`.
