local ADDON, ns = ...

-- Fakten (Quelle: Wunschliste von Selo^^ / Solomon)
ns.FACTS = {
    "Chuck Norris braucht keinen Tank. Der Boss braucht einen.",
    "Chuck Norris hat keinen Gearscore. Gear hat einen Chuck-Norris-Score.",
    "Wenn Chuck Norris /reload eingibt, startet der Server neu.",
    "Chuck Norris wartet nicht auf den Respawn. Der Respawn wartet auf Chuck Norris.",
    "Chuck Norris braucht keinen Ruhestein. Azeroth portet sich zu ihm.",
    "Chuck Norris läuft nicht durch Instanzen. Instanzen laufen vor ihm davon.",
    "Chuck Norris braucht keine Quest-Voraussetzungen. Die Quest erfüllt seine Voraussetzungen.",
    "Chuck Norris sucht keine Quest-ID. Die Quest-ID sucht Chuck Norris.",
    "Chuck Norris braucht keinen TomTom-Pfeil. Das Ziel findet ihn.",
    "Chuck Norris benutzt keinen Zygor Guide. Zygor fragt Chuck Norris nach dem Weg.",
    "Chuck Norris hat keine Aggro. Aggro hat Chuck Norris.",
    "Wenn Chuck Norris /who eingibt, steht dort nur: „Alle anderen.“",
    "Chuck Norris würfelt keine 100. Das Würfelsystem fragt ihn, welche Zahl er möchte.",
    "Chuck Norris braucht keinen Cooldown. Cooldowns brauchen eine Pause von Chuck Norris.",
    "Chuck Norris kann einen World Boss grau schlagen.",
    "Chuck Norris braucht kein BiS-Gear. Was Chuck Norris trägt, wird BiS.",
    "Chuck Norris bekommt keinen Disconnect. Der Server verliert die Verbindung zu ihm.",
    "Chuck Norris wurde einmal gegankt. Seitdem gibt es PvE-Server.",
    "Chuck Norris braucht keinen Dungeon Finder. Der Dungeon findet Chuck Norris.",
    "Chuck Norris hat keinen Main. Alle Klassen sind seine Alts.",
    "Chuck Norris braucht keine Dependency Engine. Die Quests wissen selbst, wann sie dran sind.",
    "Chuck Norris muss den richtigen Zygor Guide nicht auswählen. Zygor wechselt automatisch aus Respekt.",
    "Wenn bei Chuck Norris der TomTom-Pfeil fehlt, bewegt sich die Welt stattdessen in die richtige Richtung.",
    "Chuck Norris klickt nicht auf „Next Step“. Der nächste Step klickt auf Chuck Norris.",
    "Chuck Norris braucht kein Super Tracking. Blizzard trackt ihn.",
    "Bei Chuck Norris funktioniert das Addon immer. Bugs melden sich vorher krank.",
    "Chuck Norris hat einmal /console reloadui eingegeben. Seitdem nennt man es WoW 2.0.",
    "Chuck Norris braucht keinen Quest Resolver. Er schaut die Quest an und sie resolved sich selbst.",
    "Chuck Norris kennt die Koordinaten nicht. Die Koordinaten kennen Chuck Norris.",
    "Wenn ForeverHealFrames bei Chuck Norris die HoTs nicht anzeigt, heilt der Frame den Druiden selbst.",
    "Chuck Norris ist nicht Level 60. Level 60 ist Chuck Norris.",
    "Chuck Norris spielt keinen Resto-Druiden. Der Schaden sieht Chuck Norris und beginnt von selbst zu heilen.",
    "Chuck Norris braucht keinen Heiler. Die Wunden heilen aus Angst.",
    "Chuck Norris hat Hearthstone-Spieler nie verstanden. Sein Ruhestein war schon immer zu Hause.",
    "Chuck Norris wird nicht afk. Die Zeit pausiert für ihn.",
    "Chuck Norris stirbt nicht im Feuer. Das Feuer steht in der Gruppe und wird nicht getroffen.",
    "Chuck Norris hat Ping 0. Der Server liegt in seinem Wohnzimmer.",
    "Chuck Norris liest keine Boss-Taktik. Der Boss liest seine.",
    "Chuck Norris zahlt nie Reparaturkosten. Die Rüstung entschuldigt sich.",
    "Chuck Norris braucht keine Flasche. Die Flasche braucht Chuck Norris.",
    "Wenn Chuck Norris Bedarf drückt, gibt das Item freiwillig Gold dazu.",
    "Chuck Norris hat Ragnaros mal gesagt, er solle die Heizung ausmachen. Seitdem ist Ragnaros ein Kühlschrank.",
    "Chuck Norris wipet nicht. Die Gruppe tritt bei ihm einen Schritt zur Seite.",
    "Chuck Norris tankt Tanks. Und heilt Heiler. Und buffed Buffs.",
    "Chuck Norris fliegt nicht. Der Boden hat einfach Angst, ihn zu berühren.",
    "Chuck Norris schreibt keine Addons. Die Addons schreiben sich nach seinem Vorbild.",
    "Chuck Norris klickt Gruppenbuffs nicht. Die fehlenden Buffs entschuldigen sich und sind sofort da.",
}

-- Spezielle Sprüche für Ereignisse
ns.DEATH = {
    "Chuck Norris stirbt nicht. Der Tod hat nur einen Termin bei ihm verpasst.",
    "Du bist gestorben. Chuck Norris wäre das nie passiert.",
    "Chuck Norris hat einen Geistheiler. Er heißt Chuck Norris.",
}
ns.LEVEL = {
    "Ding! Chuck Norris hat auch mal geklingelt. Dann ging das Level zu ihm.",
    "Level-Up! Die XP haben sich bei dir bedankt. Chuck Norris hat sie nur angesehen.",
    "Level-Up! Chuck Norris levelt nicht. Die Level leveln für ihn.",
    "Glückwunsch! Chuck Norris hätte das Level einfach angeordnet.",
}

-- Sprüche, die bei Tod in den Gruppenchat gehen (/p, /i, /raid)
ns.DEATH_CHAT = {
    "Ich bin gestorben. Chuck Norris hat das nie gemacht. Ich bin also kein Chuck Norris.",
    "Kurze Info: Ich liege. Bitte ohne mich weiterkämpfen, ich schaue von unten zu.",
    "Ich war nicht tot, ich habe nur die Bodentextur geprüft.",
    "Tod Nr. X erreicht. Bitte kein Mitleid, nur Wiederbelebung.",
    "Das war kein Wipe, das war ein taktischer Sprint zum Geistheiler.",
    "Ich habe den Boss testweise gewinnen lassen. Er war schon traurig.",
    "Frage an den Heiler: War das ein Tipp oder eine Ausrede? Bitte beides ignorieren.",
    "Chuck Norris wäre nicht gestorben. Chuck Norris ist halt auch kein Hunter mit Pet-Aggro.",
    "Ich stehe gleich wieder. Bitte nichts anfassen, was brennt.",
    "Mein Gear hat entschieden, dass es Pause braucht. Ich bin nur der Überbringer.",
    "Das Feuer stand im Weg. Die Schuld liegt beim Feuer.",
    "Ich lege mich kurz hin, sonst wirkt der Boss zu stark.",
    "Laut meinem Addon war ich ordentlich gebufft. Das Addon wurde ebenfalls getötet.",
    "Ich bin tot, aber mental noch voll im Raid dabei.",
    "Neuer Rekord: Zeit bis zum Tod. Bitte alle Screenshots machen.",
}

-- Sprüche nach Ereignis
ns.EVENTS = {
    READY = {
        "Bereitschaftscheck! Chuck Norris ist immer bereit. Der Check wartet auf ihn.",
        "Haken drücken nicht vergessen. Chuck Norris hat ihn nie gedrückt, der Haken erscheint von allein.",
        "Alle bereit? Chuck Norris war schon vor dem Bereitschaftscheck bereit.",
        "Hast du Flask, Essen und Buffs? Chuck Norris braucht nichts davon, aber du schon.",
        "Bereitschaftscheck: Der Moment, in dem plötzlich alle Essen kauen.",
    },
    EPIC = {
        "Episches Item! Chuck Norris trägt kein Epic. Das Epic trägt Chuck Norris.",
        "Lila Beute! Das Item hat sich beworben, Chuck Norris hätte es nur angeguckt.",
        "Epic gedroppt. Bitte nicht gleich im Handelschat angeben.",
        "Du hast lila bekommen. Chuck Norris bekommt nur Gold, der Rest ist ihm egal.",
        "Glückwunsch zum Epic! Der Boss hat es extra für dich aufgehoben.",
    },
    LEGENDARY = {
        "LEGENDÄR! Chuck Norris braucht kein Legendary. Das Legendary braucht Chuck Norris.",
        "Orange Beute! Gleich mal Screenshot machen, bevor es jemand glaubt.",
    },
    BOSSKILL = {
        "Boss besiegt! Chuck Norris hätte ihn auch ohne Gruppe geschafft, aber es ist nett, dass ihr dabei wart.",
        "Der Boss ist down. Er wollte eigentlich nur noch Feierabend.",
        "Sieg! Der Boss hat jetzt endlich Zeit für Urlaub.",
        "Boss tot. Chuck Norris hat ihn nur kurz angesehen, ihr habt den Rest gemacht.",
        "Kill! Jetzt bitte alle gleichzeitig Bedarf drücken und still beten.",
    },
    WIPE = {
        "Wipe! Chuck Norris wipet nicht. Er lässt nur den Boss gewinnen, damit er nicht traurig ist.",
        "Das war ein Test. Der Boss hat bestanden, ihr dürft nochmal.",
        "Wipe! Schuld ist der Lag, das Feuer oder der Heiler. Sicher nicht du.",
        "Alle tot. Tipp: Nicht ins Feuer stellen. Ernsthaft.",
        "Der Geistheiler grüßt. Er kennt euch schon sehr gut.",
    },
    BOSSKILL_CHAT = {
        "Boss ist down! Das Team war gut, Chuck Norris wäre trotzdem schneller gewesen.",
        "Kill! Danke an alle, die nicht im Feuer standen.",
        "Boss besiegt. Der Tank sagt Danke, der Heiler braucht eine Pause.",
    },
    WIPE_CHAT = {
        "Das war kein Wipe, das war ein Gruppenspaziergang zum Geistheiler.",
        "Bitte alle kurz Luft holen. Und nicht ins Feuer stellen.",
        "Wipe! Nächster Versuch klappt, Chuck Norris glaubt an uns.",
    },
    QUEST = {
        "Quest abgegeben! Chuck Norris braucht keine Belohnung, die Quest bedankt sich bei ihm.",
        "Erledigt! Die Quest hatte sowieso Angst vor dir.",
        "Quest fertig. Der Questgeber fragt sich, ob du auch Urlaub planst.",
        "Abgegeben. Chuck Norris muss keine Quests abgeben, die Quest kommt zu ihm.",
    },
    DUNGEON = {
        "Dungeon betreten! Chuck Norris läuft nicht durch Dungeons, die Dungeons laufen vor ihm weg.",
        "Willkommen im Dungeon. Nichts anfassen, was nach Falle aussieht.",
        "Viel Erfolg! Chuck Norris braucht keinen Dungeon Finder, der Dungeon findet ihn.",
    },
    RAID = {
        "Raid betreten! Chuck Norris braucht keinen Raid, der Raid braucht Chuck Norris.",
        "Willkommen im Raid. Bitte nur eine Person an der Spitze, nicht fünf.",
        "Du bist im Raid. Chuck Norris ist schon da und hat den ersten Boss gekillt.",
    },
    RESS = {
        "Zurück im Leben! Chuck Norris war nie weg, er hat nur kurz zugeschaut.",
        "Wieder da! Bitte diesmal nicht ins Feuer.",
        "Wiederbelebt. Der Tod war nur ein Missverständnis.",
        "Lebendig! Chuck Norris sagt, du warst nur kurz im Pausenmodus.",
    },
    DUEL = {
        "Duell angefragt! Chuck Norris duelliert nicht, er sagt nur, wer gewinnt.",
        "Duell? Viel Glück. Chuck Norris wäre schon fertig.",
        "Wer verliert, schreibt 'GG'. Wer gewinnt, auch.",
    },
    REPAIR = {
        "Reparatur! Chuck Norris repariert nichts, die Rüstung repariert sich aus Respekt.",
        "Rüstung kaputt? Das ist der Preis für Heldentum.",
        "Hände weg von den Goldreserven, aber die Rüstung braucht das.",
    },
}
