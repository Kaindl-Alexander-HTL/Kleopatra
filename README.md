# Kleopatra VII. - Interaktives Textadventure 🏺

Ein historisches Textadventure in Prolog über das Leben der letzten Pharaonin Ägyptens.

## 📖 Über das Spiel

Übernimm die Rolle von Kleopatra VII. und treffe politische Entscheidungen, die das Schicksal Ägyptens bestimmen. Von den Thronstreitigkeiten in Alexandria bis zur finalen Konfrontation mit Rom - jede Wahl beeinflusst den Verlauf der Geschichte

## 🚀 Installation & Start

### Voraussetzungen
- SWI-Prolog oder GNU Prolog installiert

### Ubuntu/Debian:

```bashsudo apt install swi-prolog

# Repository klonen
git clone https://github.com/[dein-username]/kleopatra-adventure.git
cd kleopatra-adventure

# SWI-Prolog starten
swipl

# In Prolog: Datei laden
?- ['kleopatra.pl'].

# Spiel starten
?- start_game.

# Als ausführbare Datei kompilieren
gplc kleopatra.pl -o kleopatra_game

# Direkt ausführen
./kleopatra_game
