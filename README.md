# Kleopatra VII. - Interaktives Textadventure 🏺

Ein historisches Textadventure in Prolog über das Leben der letzten Pharaonin Ägyptens.

## 📖 Über das Spiel

Übernimm die Rolle von Kleopatra VII. und treffe politische Entscheidungen, die das Schicksal Ägyptens bestimmen. Von den Thronstreitigkeiten in Alexandria bis zur finalen Konfrontation mit Rom - jede Wahl beeinflusst den Verlauf der Geschichte.

### Kernfeatures
- 🏛️ **7 Kapitel** mit historisch akkuraten Ereignissen
- 🔀 **Verzweigte Handlung** - deine Entscheidungen verändern die Geschichte
- 👑 **Multiple Enden** - 3 verschiedene Schicksale für Kleopatra
- 📚 **Historischer Kontext** - basiert auf echten Ereignissen um 48-30 v. Chr.
- 🎭 **Charakterentwicklung** - von der Thronanwärterin zur Legende

## 🎮 Spielablauf

1. **Thronstreit** - Diplomatisch, kämpferisch oder taktisch gegen Ptolemaios XIII.
2. **Caesar-Begegnung** - Verführung, Konfrontation oder Ablehnung des römischen Feldherrn
3. **Machtsicherung** - Stabilisierung durch Reformen, Härte oder göttliche Legitimation
4. **Caesars Tod** - Reaktion auf die Iden des März und neue Machtverhältnisse
5. **Antonius-Bündnis** - Verschiedene Beziehungsformen zum römischen Triumvir
6. **Actium-Schlacht** - Endkampf, Flucht oder Kapitulation
7. **Finales Schicksal** - Ehrenhafter Tod, Gefangenschaft oder geheimnisvolles Exil

## 🚀 Installation & Start

### Voraussetzungen
- SWI-Prolog oder GNU Prolog installiert

### Ubuntu/Debian:
```bash
sudo apt install swi-prolog

# Repository klonen
git clone https://github.com/[dein-username]/kleopatra-adventure.git
cd kleopatra-adventure

# SWI-Prolog starten
swipl

# In Prolog: Datei laden
?- [kleopatra].

# Spiel starten
?- start_game.

# Als ausführbare Datei kompilieren
gplc kleopatra.pl -o kleopatra_game

# Direkt ausführen
./kleopatra_game
