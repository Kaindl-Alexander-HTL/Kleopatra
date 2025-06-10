% ================================================================
% KLEOPATRA VII. - INTERAKTIVES TEXTADVENTURE IN PROLOG
% Korrigierte Version fuer Standard-Prolog-Systeme
% ================================================================

% Dynamische Praedikate deklarieren - ermoeglicht Aenderungen zur Laufzeit
% Diese Fakten koennen waehrend des Spiels hinzugefuegt, entfernt und geaendert werden
:- dynamic(game_state/2).      % Speichert den aktuellen Spielzustand (Kapitel, Status, etc.)
:- dynamic(player_choice/2).   % Speichert die Entscheidungen des Spielers
:- dynamic(relationship/2).    % Speichert Beziehungen zu anderen Charakteren

% NEUES Predikat fuer den Statusbericht
show_status :-
    nl,
    write('AKTUELLER STATUS:'), nl,
    write('-----------------'), nl,
    (   game_state(chapter, CurrentChapter) ->
        write('Kapitel: '), write(CurrentChapter), nl
    ;   true
    ),
    (   game_state(egypt_status, Status) ->
        write('Status Aegyptens: '), write(Status), nl
    ;   true
    ),
    (   game_state(reputation, Rep) ->
        write('Dein Ruf: '), write(Rep), nl
    ;   true
    ),
    (   game_state(popular_support, Support) -> % Annahme: popular_support ist bereits integriert
        write('Volksunterstuetzung: '), write(Support), write('%'), nl
    ;   true
    ),
    (   game_state(treasury, Treasury) ->
        write('Staatsschatz: '), write(Treasury), write(' Einheiten'), nl
    ;   true
    ),
    write('-----------------'), nl, nl.

% ================================================================
% SPIELSTART UND INITIALISIERUNG
% ================================================================

% Hauptstartpunkt des Spiels - initialisiert alle Werte und startet das erste Kapitel
start_game :-
    % Alle vorherigen Spielstaende loeschen fuer einen sauberen Neustart
    retractall(game_state(_, _)),
    retractall(player_choice(_, _)),
    retractall(relationship(_, _)),

    % Initialer Spielzustand setzen - Grundwerte fuer das Spiel
    asserta(game_state(chapter, 1)),                    % Startet in Kapitel 1
    asserta(game_state(egypt_status, instabil)),        % Aegypten ist anfangs instabil
    asserta(game_state(reputation, rechtmaessige_erbin)),     % Kleopatra ist rechtmaessige Erbin
    asserta(relationship(ptolemy_xiii, feindselig)),       % Bruder ist feindlich gesinnt
    asserta(game_state(popular_support, 50)),           % Annahme: Initialisierung von popular_support
    asserta(game_state(treasury, 100)),                 % NEU: Initialer Staatsschatz

    write('================================================================'), nl,
    write('          KLEOPATRA VII. - DAS SCHICKSAL AEGYPTENS'), nl,
    write('================================================================'), nl, nl,
    write('Du bist Kleopatra VII., Tochter der Pharaonen, Erbin des'), nl,
    write('maechtigsten Reiches der Antike. Doch dein Bruder Ptolemaios XIII.'), nl,
    write('bedroht deinen rechtmaessigen Anspruch auf den Thron.'), nl, nl,
    write('Jede Entscheidung wird das Schicksal Aegyptens bestimmen...'), nl, nl,

    chapter_1.

% ================================================================
% KAPITEL 1: DER THRONSTREIT
% ================================================================
chapter_1 :-
    write('KAPITEL 1: DER THRONSTREIT'), nl,
    write('----------------------------------------'), nl,
    show_status, % NEU: Status anzeigen
    write('Alexandria, 48 v. Chr. Dein Bruder Ptolemaios XIII. hat sich'), nl,
    write('gegen dich erhoben und beansprucht den Thron. Seine Berater'), nl,
    write('Pothinos und Achillas haben bereits Truppen mobilisiert.'), nl, nl,
    write('Wie gehst du vor?'), nl, nl,
    write('1. Diplomatisch - Verhandlungen mit den Priestern fuehren'), nl,
    write('2. Kaempferisch - Sofort militaerischen Widerstand organisieren'), nl,
    write('3. Taktisch - Heimlich Verbuendete sammeln und abwarten'), nl, nl,
    write('Deine Wahl (1-3): '),

    read(Choice),
    handle_chapter_1_choice(Choice).

handle_chapter_1_choice(1) :-
    asserta(player_choice(chapter_1, diplomatisch)),
    write('Du suchst die Priester von Memphis auf. Durch deine Kenntnis'), nl,
    write('der aegyptischen Sprache und Kultur gewinnst du ihre Unterstuetzung.'), nl,
    % Update popular_support (Annahme: Logik aus vorheriger Aenderung)
    game_state(popular_support, OldSupportDip),
    retract(game_state(popular_support, OldSupportDip)),
    NewSupportDip is OldSupportDip + 10,
    asserta(game_state(popular_support, NewSupportDip)),
    % NEU: Update treasury
    game_state(treasury, OldTreasuryDip),
    retract(game_state(treasury, OldTreasuryDip)),
    NewTreasuryDip is OldTreasuryDip + 10,
    asserta(game_state(treasury, NewTreasuryDip)),
    write('Die Priester unterstuetzen dich auch mit Mitteln aus dem Tempelschatz.'), nl,
    asserta(relationship(priester, verbuendet)),
    retract(game_state(reputation, _)),
    asserta(game_state(reputation, kultivierte_pharaonin)),
    chapter_2.

handle_chapter_1_choice(2) :-
    asserta(player_choice(chapter_1, kaempferisch)),
    write('Du rufst deine Truppen zusammen und stellst dich offen'), nl,
    write('gegen Ptolemaios. Ein blutiger Buergerkrieg beginnt.'), nl,
    % Update popular_support (Annahme: Logik aus vorheriger Aenderung)
    game_state(popular_support, OldSupportCom),
    retract(game_state(popular_support, OldSupportCom)),
    NewSupportCom is OldSupportCom - 10,
    asserta(game_state(popular_support, NewSupportCom)),
    % NEU: Update treasury
    game_state(treasury, OldTreasuryCom),
    retract(game_state(treasury, OldTreasuryCom)),
    NewTreasuryCom is OldTreasuryCom - 30,
    asserta(game_state(treasury, NewTreasuryCom)),
    write('Der Buergerkrieg fordert nicht nur Menschenleben, sondern verschlingt auch Unsummen aus der Staatskasse.'), nl,
    retract(relationship(ptolemy_xiii, feindselig)), % War vorher 'hostile', jetzt 'feindselig' durch start_game
    asserta(relationship(ptolemy_xiii, offener_krieg)),
    retract(game_state(egypt_status, _)),
    asserta(game_state(egypt_status, buergerkrieg)),
    % Volksunterstuetzung anpassen
    chapter_2.

handle_chapter_1_choice(3) :-
    asserta(player_choice(chapter_1, taktisch)),
    write('Du ziehst dich zunaechst zurueck und baust im Verborgenen'), nl,
    write('ein Netzwerk aus Spionen und Getreuen auf.'), nl,
    % Update popular_support (Annahme: Logik aus vorheriger Aenderung)
    game_state(popular_support, OldSupportTac),
    retract(game_state(popular_support, OldSupportTac)),
    NewSupportTac is OldSupportTac + 5,
    asserta(game_state(popular_support, NewSupportTac)),
    % NEU: Update treasury
    game_state(treasury, OldTreasuryTac),
    retract(game_state(treasury, OldTreasuryTac)),
    NewTreasuryTac is OldTreasuryTac - 10,
    asserta(game_state(treasury, NewTreasuryTac)),
    write('Der Aufbau deines Netzwerks erfordert finanzielle Mittel, doch deine Umsicht staerkt das Vertrauen.'), nl,
    retract(game_state(reputation, _)),
    asserta(game_state(reputation, listige_strategin)),
    asserta(relationship(spione, verbuendet)),
    % Volksunterstuetzung anpassen
    chapter_2.

handle_chapter_1_choice(_) :-
    write('Ungueltige Wahl. Bitte waehle 1, 2 oder 3.'), nl,
    chapter_1.

% ================================================================
% KAPITEL 2: BEGEGNUNG MIT CAESAR
% ================================================================
chapter_2 :-
    retract(game_state(chapter, _)),
    asserta(game_state(chapter, 2)),
    nl, nl,
    write('KAPITEL 2: CAESAR KOMMT NACH ALEXANDRIA'), nl,
    write('----------------------------------------'), nl,
    show_status, % NEU: Status anzeigen
    write('Gaius Julius Caesar ist in Alexandria eingetroffen. Der'), nl,
    write('maechtigste Mann Roms koennte dein Schicksal wenden - oder besiegeln.'), nl, nl,

    % Verschiedene Einleitungen je nach vorheriger Wahl
    (player_choice(chapter_1, diplomatisch) ->
        write('Dank deiner Unterstuetzung bei den Priestern hast du Caesars'), nl,
        write('Aufmerksamkeit gewonnen.') ;
    player_choice(chapter_1, kaempferisch) ->
        write('Caesar ist beunruhigt ueber den Buergerkrieg, der seine'), nl,
        write('Kornlieferungen gefaehrdet.') ;
    % Annahme: player_choice(chapter_1, taktisch)
        write('Deine Spione haben dir Caesars Plaene verraten.')
    ), nl, nl,

    write('Wie begegnest du dem roemischen Feldherrn?'), nl, nl,
    write('1. Verfuehrung - Mit Charme und Schoenheit fuer dich gewinnen'), nl,
    write('2. Konfrontation - Als gleichberechtigte Herrscherin auftreten'), nl,
    write('3. Ablehnung - Die roemische Einmischung kategorisch zurueckweisen'), nl, nl,
    write('Deine Wahl (1-3): '),

    read(Choice),
    handle_chapter_2_choice(Choice).

handle_chapter_2_choice(1) :-
    asserta(player_choice(chapter_2, verfuehrung)),
    write('Du laesst dich in einem kostbaren Teppich zu Caesar bringen.'), nl,
    write('Deine Schoenheit und dein Witz betoeren den Roemer vollstaendig.'), nl,
    write('Caesar wird zu deinem Liebhaber und maechtigsten Verbuendeten.'), nl,
    asserta(relationship(caesar, liebhaber_verbuendeter)),
    retract(game_state(egypt_status, _)),
    asserta(game_state(egypt_status, roemisch_geschuetzt)),
    chapter_3.

handle_chapter_2_choice(2) :-
    asserta(player_choice(chapter_2, konfrontation)),
    write('Du trittst Caesar als Pharaonin entgegen und forderst'), nl,
    write('Respekt fuer Aegyptens Souveraenitaet. Caesar ist beeindruckt'), nl,
    write('von deiner Staerke und bietet ein Buendnis als Gleichberechtigte.'), nl,
    asserta(relationship(caesar, respektierter_verbuendeter)),
    retract(game_state(reputation, _)),
    asserta(game_state(reputation, starke_pharaonin)),
    chapter_3.

handle_chapter_2_choice(3) :-
    asserta(player_choice(chapter_2, ablehnung)),
    write('Du weist Caesar schroff zurueck. "Aegypten braucht Rom nicht!"'), nl,
    write('Caesar ist erzuernt, aber auch fasziniert von deinem Mut.'), nl,
    write('Er droht mit Konsequenzen, zieht sich aber vorerst zurueck.'), nl,
    asserta(relationship(caesar, feindseliger_respekt)),
    retract(game_state(egypt_status, _)),
    asserta(game_state(egypt_status, trotzige_unabhaengigkeit)),
    chapter_3.

handle_chapter_2_choice(_) :-
    write('Ungueltige Wahl. Bitte waehle 1, 2 oder 3.'), nl,
    chapter_2.

% ================================================================
% KAPITEL 3: MACHT SICHERN IN ALEXANDRIA
% ================================================================
chapter_3 :-
    retract(game_state(chapter, _)),
    asserta(game_state(chapter, 3)),
    nl, nl,
    write('KAPITEL 3: DIE MACHT FESTIGEN'), nl,
    write('----------------------------------------'), nl,
    show_status, % NEU: Status anzeigen
    % Kontextabhaengige Beschreibung
    (   relationship(caesar, liebhaber_verbuendeter) ->
        (   write('Mit Caesars Unterstuetzung hast du Ptolemaios XIII. besiegt.'), nl,
            write('Doch Widerstand brodelt in Alexandria.')
        )
    ;   relationship(caesar, respektierter_verbuendeter) ->
        (   write('Das Buendnis mit Caesar hat dir militaerische Vorteile gebracht.'), nl,
            write('Nun musst du deine Herrschaft stabilisieren.')
        )
    ;   % Annahme: relationship(caesar, feindseliger_respekt) oder anderer Status
        (   write('Ohne roemische Hilfe musst du deine Macht durch andere'), nl,
            write('Mittel sichern.')
        )
    ), nl, nl,

    write('Wie konsolidierst du deine Herrschaft?'), nl, nl,
    write('1. Reformen - Steuern senken und das Volk unterstuetzen'), nl,
    write('2. Eliminierung - Politische Gegner ausschalten'), nl,
    write('3. Kultische Legitimation - Als Goettin Isis auftreten'), nl,
    write('4. Geheime Vorbereitung - Einen Fluchtweg und geheime Ressourcen anlegen'), nl, nl,
    write('Deine Wahl (1-4): '),

    read(Choice),
    handle_chapter_3_choice(Choice).

handle_chapter_3_choice(1) :-
    asserta(player_choice(chapter_3, reformen)),
    % Update popular_support (Annahme: Logik aus vorheriger Aenderung)
    game_state(popular_support, OldSupportRef),
    retract(game_state(popular_support, OldSupportRef)),
    NewSupportRef is OldSupportRef + 15,
    asserta(game_state(popular_support, NewSupportRef)),
    % NEU: Update treasury
    game_state(treasury, OldTreasuryRef),
    retract(game_state(treasury, OldTreasuryRef)),
    NewTreasuryRef is OldTreasuryRef - 20,
    asserta(game_state(treasury, NewTreasuryRef)),
    write('Du fuehrst Landreformen durch und senkst die Steuern.'), nl,
    write('Das Volk liebt dich dafuer, auch wenn es die Staatskasse kurzfristig belastet.'), nl,
    write('Die Priester sind jedoch unzufrieden ueber den Einflussverlust.'), nl,
    asserta(relationship(volk, geliebt)),
    retract(game_state(egypt_status, _)),
    asserta(game_state(egypt_status, stabil_beliebt)),
    % Volksunterstuetzung anpassen
    chapter_4.

handle_chapter_3_choice(2) :-
    asserta(player_choice(chapter_3, eliminierung)),
    % Update popular_support (Annahme: Logik aus vorheriger Aenderung)
    game_state(popular_support, OldSupportEli),
    retract(game_state(popular_support, OldSupportEli)),
    NewSupportEli is OldSupportEli - 10,
    asserta(game_state(popular_support, NewSupportEli)),
    % NEU: Update treasury
    game_state(treasury, OldTreasuryEli),
    retract(game_state(treasury, OldTreasuryEli)),
    NewTreasuryEli is OldTreasuryEli + 15,
    asserta(game_state(treasury, NewTreasuryEli)),
    write('Du laesst Pothinos hinrichten und verbannst andere Gegner.'), nl,
    write('Alexandria ist ruhig, aber aus Furcht, nicht aus Liebe.'), nl,
    write('Die Gueter der Verraeter fuellen jedoch die Staatskasse.'), nl,
    retract(game_state(reputation, _)),
    asserta(game_state(reputation, gefuerchtete_herrscherin)),
    retract(game_state(egypt_status, _)),
    asserta(game_state(egypt_status, stabil_durch_furcht)),
    % Volksunterstuetzung anpassen
    chapter_4.

handle_chapter_3_choice(3) :-
    asserta(player_choice(chapter_3, kultische_legitimation)),
    % Update popular_support (Annahme: Logik aus vorheriger Aenderung)
    game_state(popular_support, OldSupportDiv),
    retract(game_state(popular_support, OldSupportDiv)),
    NewSupportDiv is OldSupportDiv + 5,
    asserta(game_state(popular_support, NewSupportDiv)),
    % NEU: Update treasury
    game_state(treasury, OldTreasuryDiv),
    retract(game_state(treasury, OldTreasuryDiv)),
    NewTreasuryDiv is OldTreasuryDiv - 15,
    asserta(game_state(treasury, NewTreasuryDiv)),
    write('Du inszenierst praechtige Zeremonien als lebende Goettin Isis.'), nl,
    write('Die religioese Ehrfurcht staerkt deine mystische Autoritaet, auch wenn die Zeremonien kostspielig sind.'), nl,
    retract(game_state(reputation, _)),
    asserta(game_state(reputation, goettliche_pharaonin)),
    asserta(relationship(priester, ergeben)),
    % Volksunterstuetzung anpassen
    write('Das Volk ist ehrfuerchtig angesichts deiner goettlichen Erscheinung, was ihre Verehrung steigert.'), nl,
    chapter_4.

handle_chapter_3_choice(4) :- % Neue Wahlbehandlung (Annahme: popular_support bleibt unveraendert)
    asserta(player_choice(chapter_3, geheime_vorbereitung)),
    % NEU: Update treasury
    game_state(treasury, OldTreasuryPrep),
    retract(game_state(treasury, OldTreasuryPrep)),
    NewTreasuryPrep is OldTreasuryPrep - 25,
    asserta(game_state(treasury, NewTreasuryPrep)),
    write('Du beginnst im Geheimen mit den Vorbereitungen fuer alle Eventualitaeten.'), nl,
    write('Versteckte Fluchtwege werden angelegt und Ressourcen an sicheren Orten deponiert.'), nl,
    write('Das Anlegen geheimer Ressourcen und Fluchtwege ist eine teure, aber moeglicherweise lebensrettende Investition in die Zukunft.'), nl,
    asserta(game_state(geheime_vorbereitung, true)),
    chapter_4.

handle_chapter_3_choice(_) :-
    write('Ungueltige Wahl. Bitte waehle 1, 2, 3 oder 4.'), nl, % Angepasst fuer 4 Optionen
    chapter_3.

% ================================================================
% KAPITEL 4: CAESARS TOD
% ================================================================
chapter_4 :-
    retract(game_state(chapter, _)),
    asserta(game_state(chapter, 4)),
    nl, nl,
    write('KAPITEL 4: DIE IDEN DES MAERZ'), nl,
    write('----------------------------------------'), nl,
    show_status, % NEU: Status anzeigen
    write('Schreckensnachrichten aus Rom: Caesar wurde ermordet!'), nl,
    write('Brutus und die Verschwoerer haben den Diktator an den'), nl,
    write('Iden des Maerz niedergestochen.'), nl, nl,

    % Reaktion je nach Beziehung zu Caesar
    (relationship(caesar, liebhaber_verbuendeter) ->
        write('Dein Geliebter ist tot. Doch sein Erbe - euer gemeinsamer'), nl,
        write('Sohn Caesarion - koennte Roms Zukunft bestimmen.'), nl,
        asserta(game_state(caesarion, sohn)) ; % War 'son'
    relationship(caesar, respektierter_verbuendeter) ->
        write('Ein wertvoller Verbuendeter ist verloren. Rom wird chaotisch.') ;
    % Annahme: relationship(caesar, feindseliger_respekt)
        write('Der Tyrann ist tot, aber was bedeutet das fuer Aegypten?')
    ), nl, nl,

    write('Marcus Antonius und Octavian ringen um Caesars Nachfolge.'), nl,
    write('Wie reagierst du auf diese neue Lage?'), nl, nl,
    write('1. Abwarten - Die roemischen Buergerkriege beobachten'), nl,
    write('2. Antonius umwerben - Den charismatischeren Erben unterstuetzen'), nl,
    write('3. Unabhaengigkeit - Die Schwaeche Roms fuer Aegypten nutzen'), nl, nl,
    write('Deine Wahl (1-3): '),

    read(Choice),
    handle_chapter_4_choice(Choice).

handle_chapter_4_choice(1) :-
    asserta(player_choice(chapter_4, abwarten)),
    write('Du haeltst dich aus den roemischen Wirren heraus und'), nl,
    write('staerkst waehrenddessen Aegyptens innere Macht.'), nl,
    retract(game_state(egypt_status, _)),
    asserta(game_state(egypt_status, gestaerkt_neutral)),
    chapter_5.

handle_chapter_4_choice(2) :-
    asserta(player_choice(chapter_4, annaeherung_antonius)),
    write('Du sendest heimliche Botschaften an Marcus Antonius.'), nl,
    write('Der maechtige Triumvir zeigt Interesse an einem Buendnis.'), nl,
    asserta(relationship(antonius, potenzieller_verbuendeter)),
    chapter_5.

handle_chapter_4_choice(3) :-
    asserta(player_choice(chapter_4, unabhaengigkeit_erklaeren)),
    write('Du verkuendest Aegyptens voellige Unabhaengigkeit und'), nl,
    write('beginnst, ein anti-roemisches Buendnis zu schmieden.'), nl,
    retract(game_state(egypt_status, _)),
    asserta(game_state(egypt_status, unabhaengig_trotzig)),
    asserta(relationship(rom, feindselig)),
    chapter_5.

handle_chapter_4_choice(_) :-
    write('Ungueltige Wahl. Bitte waehle 1, 2 oder 3.'), nl,
    chapter_4.

% ================================================================
% KAPITEL 5: BUENDNIS MIT ANTONIUS
% ================================================================
chapter_5 :-
    retract(game_state(chapter, _)),
    asserta(game_state(chapter, 5)),
    nl, nl,
    write('KAPITEL 5: DER TANZ MIT ANTONIUS'), nl,
    write('----------------------------------------'), nl,
    show_status, % NEU: Status anzeigen
    write('Marcus Antonius, Herr ueber den Osten des Roemischen Reiches,'), nl,
    write('hat dich nach Tarsus eingeladen. Es ist ein politischer'), nl,
    write('Tanz auf Leben und Tod.'), nl, nl,

    % Verschiedene Szenarien
    (player_choice(chapter_4, annaeherung_antonius) ->
        write('Deine vorherigen Annaeherungsversuche haben Fruechte getragen.') ;
    player_choice(chapter_4, unabhaengigkeit_erklaeren) -> % War 'independence'
        write('Antonius will dich zur Rechenschaft ziehen fuer deine'), nl,
        write('Unabhaengigkeitsbestrebungen.') ;
    % Annahme: player_choice(chapter_4, abwarten)
        write('Antonius ist neugierig auf die legendaere Pharaonin.')
    ), nl, nl,

    write('Wie begegnest du dem maechtigsten Mann des Ostens?'), nl, nl,
    write('1. Verfuehrung - Mit legendaerer Pracht und Sinnlichkeit'), nl,
    write('2. Gleichberechtigung - Als Herrscherin auf Augenhoehe'), nl,
    write('3. Unterwerfung - Als demuetige Vasallin Roms'), nl, nl,
    write('Deine Wahl (1-3): '),

    read(Choice),
    handle_chapter_5_choice(Choice).

handle_chapter_5_choice(1) :-
    asserta(player_choice(chapter_5, verfuehrung_antonius)),
    write('Du kommst als Aphrodite verkleidet auf deiner goldenen'), nl,
    write('Barke nach Tarsus. Antonius ist voellig bezaubert und'), nl,
    write('wird dein Liebhaber und maechtiger Beschuetzer.'), nl,
    asserta(relationship(antonius, liebhaber_beschuetzer)),
    retract(game_state(egypt_status, _)),
    asserta(game_state(egypt_status, roemisch_verbuendet)),
    chapter_6.

handle_chapter_5_choice(2) :-
    asserta(player_choice(chapter_5, gleichberechtigte_partnerschaft)),
    write('Du trittst Antonius als gleichberechtigte Partnerin'), nl,
    write('entgegen. Er respektiert deine Macht und ihr schmiedet'), nl,
    write('ein Buendnis zweier Herrscher.'), nl,
    asserta(relationship(antonius, gleichberechtigter_verbuendeter)),
    retract(game_state(egypt_status, _)),
    asserta(game_state(egypt_status, unabhaengig_verbuendet)),
    chapter_6.

handle_chapter_5_choice(3) :-
    asserta(player_choice(chapter_5, unterwerfung)),
    write('Du unterwirfst dich demonstrativ der roemischen Macht.'), nl,
    write('Antonius ist befriedigt, aber Aegypten wird zur Provinz.'), nl,
    asserta(relationship(antonius, oberherr)),
    retract(game_state(egypt_status, _)),
    asserta(game_state(egypt_status, roemische_provinz)),
    chapter_6.

handle_chapter_5_choice(_) :-
    write('Ungueltige Wahl. Bitte waehle 1, 2 oder 3.'), nl,
    chapter_5.

% ================================================================
% KAPITEL 6: KRIEG GEGEN OCTAVIAN
% ================================================================
chapter_6 :-
    retract(game_state(chapter, _)),
    asserta(game_state(chapter, 6)),
    nl, nl,
    write('KAPITEL 6: DER ENDKAMPF NAHT'), nl,
    write('----------------------------------------'), nl,
    show_status, % NEU: Status anzeigen
    write('Octavian hat sich zum Augustus erhoben und fordert'), nl,
    write('die Alleinherrschaft ueber Rom. Ein finaler Krieg zwischen'), nl,
    write('Ost und West ist unvermeidlich.'), nl,

    % Dynamisches Element basierend auf Volksunterstuetzung
    (   game_state(popular_support, SupportValue), SupportValue > 65 ->
        write('Dank deiner hohen Beliebtheit im Volk sind viele Aegypter bereit,'), nl,
        write('dir bis zum Letzten beizustehen und die Verteidigung zu staerken!'), nl
    ;   game_state(popular_support, SupportValue), SupportValue < 35 ->
        write('Die Moral im Land ist jedoch angespannt. Nicht alle sind von deinem'), nl,
        write('Kurs ueberzeugt, was die Mobilisierung erschwert.'), nl
    ;   true % Standardfall, keine zusaetzliche Nachricht
    ), nl,

    % Kontextabhaengige Situation
    (relationship(antonius, liebhaber_beschuetzer) -> % War lover_protector
        write('Antonius ist bereit, fuer dich und eure Liebe zu kaempfen.'), nl,
        write('Eure vereinten Flotten sind maechtig.') ;
    relationship(antonius, gleichberechtigter_verbuendeter) -> % War equal_ally
        write('Das Buendnis mit Antonius gibt dir starke militaerische'), nl,
        write('Optionen gegen Octavian.') ;
    relationship(antonius, oberherr) -> % War overlord
        write('Antonius befiehlt dir, Truppen fuer seinen Krieg zu stellen.') ;
    % Annahme: andere Beziehung zu Antonius oder keine starke Beziehung
        write('Du stehst allein gegen die roemische Uebermacht.')
    ), nl, nl,

    write('Die Schlacht von Actium steht bevor. Was ist dein Plan?'), nl, nl,
    write('1. Endkampf - Alles auf eine Karte setzen'), nl,
    write('2. Flucht - Mit der Flotte nach Aegypten entkommen'), nl,
    write('3. Kapitulation - Sich Octavian ergeben und um Gnade bitten'), nl, nl,
    write('Deine Wahl (1-3): '),

    read(Choice),
    handle_chapter_6_choice(Choice).

handle_chapter_6_choice(1) :-
    asserta(player_choice(chapter_6, endkampf)),
    write('Du kaempfst mit aller Macht bei Actium. Doch Octavians'), nl,
    write('Flotte ist ueberlegen. Die Schlacht ist verloren...'), nl,
    asserta(game_state(schlacht_ergebnis, niederlage)),
    chapter_7.

handle_chapter_6_choice(2) :-
    asserta(player_choice(chapter_6, flucht)),
    write('Im entscheidenden Moment wendest du deine Schiffe und'), nl,
    write('entkommst mit einem Teil der Flotte nach Alexandria.'), nl,
    asserta(game_state(schlacht_ergebnis, entkommen)),
    chapter_7.

handle_chapter_6_choice(3) :-
    asserta(player_choice(chapter_6, kapitulation)),
    write('Du gibst auf und ergibst dich Octavian. Er gewaehrt dir'), nl,
    write('vorerst Gnade, aber zu welchem Preis?'), nl,
    asserta(game_state(schlacht_ergebnis, kapituliert)),
    chapter_7.

handle_chapter_6_choice(_) :-
    write('Ungueltige Wahl. Bitte waehle 1, 2 oder 3.'), nl,
    chapter_6.

% ================================================================
% KAPITEL 7: DAS SCHICKSAL ENTSCHEIDET
% ================================================================
chapter_7 :-
    retract(game_state(chapter, _)),
    asserta(game_state(chapter, 7)),
    nl, nl,
    write('KAPITEL 7: DIE LETZTE ENTSCHEIDUNG'), nl,
    write('----------------------------------------'), nl,
    show_status, % NEU: Status anzeigen
    % Verschiedene Ausgangssituationen
    (   game_state(schlacht_ergebnis, niederlage) ->
        write('Du bist in deinem Palast gefangen.')
    ;   game_state(schlacht_ergebnis, entkommen) ->
        write('Du bist nach Alexandria entkommen, aber Octavian rueckt naeher.')
    ;   game_state(schlacht_ergebnis, kapituliert) ->
        write('Du hast kapituliert. Octavian wird bald ueber dein Schicksal entscheiden.')
    ;   % Fallback, sollte nicht eintreten bei korrekter Logik
        write('Die Situation ist unklar, aber Octavian ist der Sieger.')
    ), nl, nl,

    write('Octavian steht vor den Toren. Deine letzte Stunde hat geschlagen.'), nl,
    write('Wie wirst du enden?'), nl, nl,
    write('1. Selbstmord durch Schlangengift - Ein wuerdiges Ende fuer eine Pharaonin'), nl,
    write('2. Verhandlung - Versuchen, mit Octavian einen Deal auszuhandeln'), nl,
    write('3. Fluchtversuch - Trotz allem versuchen zu entkommen (benoetigt geheime_vorbereitung)'), nl, nl,
    write('Deine Wahl (1-3): '),

    read(FinalChoice),
    handle_final_choice(FinalChoice).

% Praedikate fuer das Spielende und die finale Punktzahl
% (handle_final_choice/1, endings, final_score etc. should follow here)
% Make sure these are defined or the call to handle_final_choice will fail.

% Beispielhafte Struktur fuer handle_final_choice, falls noch nicht vorhanden:
handle_final_choice(1) :-
    asserta(player_choice(chapter_7, selbstmord)),
    ending_heroic_death.

handle_final_choice(2) :-
    asserta(player_choice(chapter_7, verhandlung)),
    ending_negotiated_fate.

handle_final_choice(3) :-
    asserta(player_choice(chapter_7, fluchtversuch)),
    (   game_state(geheime_vorbereitung, true) ->
        ending_mysterious_exile
    ;   write('Dein Fluchtversuch ohne Vorbereitung scheitert klacglich...'), nl,
        ending_captured_alive % Beispiel fuer ein alternatives Ende
    ).

handle_final_choice(_) :-
    write('Ungueltige Wahl. Bitte waehle 1, 2 oder 3.'), nl,
    chapter_7.

% End-Praedikate (Beispiele, muessen ggf. angepasst/erweitert werden)
ending_heroic_death :-
    write('Du waehlst den Tod durch die Schlange. Ein Ende, das Legenden schaffen wird.'), nl,
    (   game_state(caesarion, sohn) ->
        write('Caesarion, dein Sohn, wird von Octavian verschont und als Koenig von Aegypten eingesetzt, wenn auch unter roemischer Kontrolle.'), nl,
        asserta(game_state(egypt_status, vasallenstaat_unter_caesarion))
    ;   write('Aegypten faellt endgueltig an Rom.'), nl,
        asserta(game_state(egypt_status, roemische_provinz_endgueltig))
    ),
    final_score.

ending_negotiated_fate :-
    write('Octavian gewaehrt dir das Leben, aber du wirst im Triumphzug in Rom vorgefuehrt.'), nl,
    write('Deine Kinder werden verschont, aber Aegypten ist nun eine roemische Provinz.'), nl,
    retractall(game_state(egypt_status, _)), % Status Aegyptens aktualisieren
    asserta(game_state(egypt_status, roemische_provinz_verhandelt)),
    retractall(game_state(reputation, _)), % Ruf aktualisieren
    asserta(game_state(reputation, gedemuetigte_koenigin)),
    final_score.

ending_mysterious_exile :-
    write('Dank deiner geheimen Vorbereitungen gelingt dir die Flucht!'), nl,
    (   game_state(egypt_status, unabhaengig_verbuendet) -> % Beispielbedingung
        write('Du erreichst ein verborgenes Exil und lebst unter falschem Namen weiter, waehrend Aegypten unter roemischer Herrschaft steht, aber deine Legende lebt.'), nl,
        asserta(game_state(reputation, legende_im_exil))
    ;   game_state(geheime_vorbereitung, true) ->
        write('Du entkommst und verschwindest in den Weiten des Ostens. Dein Schicksal bleibt ein Mysterium.'), nl,
        asserta(game_state(reputation, mysterium_des_ostens))
    ;   write('Du entkommst, aber dein weiteres Schicksal ist ungewiss.'), nl
    ),
    retractall(game_state(egypt_status, _)),
    asserta(game_state(egypt_status, ungewiss_nach_flucht)),
    final_score.

ending_captured_alive :-
    write('Dein Fluchtversuch scheitert. Du wirst gefangen genommen und Octavian vorgefuehrt.'), nl,
    write('Dein Schicksal ist nun das einer Gefangenen Roms.'), nl,
    retractall(game_state(egypt_status, _)),
    asserta(game_state(egypt_status, roemische_provinz_gefangen)),
    retractall(game_state(reputation, _)),
    asserta(game_state(reputation, gefangene_koenigin)),
    final_score.

% FINALE PUNKTZAHL UND AUSWERTUNG
final_score :-
    nl, nl,
    write('DEINE REISE ZUSAMMENGEFASST:'), nl,
    write('----------------------------------------'), nl,

    % Kapitel 1 Analyse (Annahme: bereits erweitert)
    (   player_choice(chapter_1, diplomatisch) -> % war: diplomatic
        write('Kapitel 1: Du warst eine weise Diplomatin.')
    ;   player_choice(chapter_1, kaempferisch) -> % war: combative
        write('Kapitel 1: Du warst eine entschlossene Kriegerin.')
    ;   player_choice(chapter_1, taktisch) -> % war: tactical
        write('Kapitel 1: Du warst eine kluge Strategin.')
    ;   write('Kapitel 1: Deine erste Wahl praegte deinen Weg.')
    ), nl,

    % Kapitel 2 Analyse (Annahme: bereits erweitert)
    (   player_choice(chapter_2, verfuehrung) -> % war: seduction
        write('Kapitel 2: Du nutztest deine Anziehungskraft geschickt.')
    ;   player_choice(chapter_2, konfrontation) -> % war: confrontation
        write('Kapitel 2: Du warst eine respektierte Herrscherin.')
    ;   player_choice(chapter_2, ablehnung) -> % war: rejection
        write('Kapitel 2: Du zeigtest unbeugsamen Stolz.')
    ;   write('Kapitel 2: Deine Begegnung mit Caesar war entscheidend.')
    ), nl,

    % Kapitel 3 Analyse (Annahme: bereits erweitert)
    (   player_choice(chapter_3, reformen) -> % war: reform
        write('Kapitel 3: Du setztest auf Reformen und Volksnaehe.')
    ;   player_choice(chapter_3, eliminierung) -> % war: elimination
        write('Kapitel 3: Du sichertest deine Macht mit harter Hand.')
    ;   player_choice(chapter_3, goettlich) -> % war: divine
        write('Kapitel 3: Du legitimiertest dich durch goettliche Aura.')
    ;   player_choice(chapter_3, geheime_vorbereitung) -> % war: secret_prep
        write('Kapitel 3: Du trafast weise Vorbereitungen im Geheimen.')
    ;   write('Kapitel 3: Deine Konsolidierung der Macht war ein wichtiger Schritt.')
    ), nl,

    % Kapitel 4 Analyse (Annahme: bereits erweitert)
    (   player_choice(chapter_4, abwarten) -> % war: wait
        write('Kapitel 4: Du beobachtetest die Wirren Roms abwartend.')
    ;   player_choice(chapter_4, annaeherung_an_antonius) -> % war: approach_antony
        write('Kapitel 4: Du suchtest die Naehe zu Marcus Antonius.')
    ;   player_choice(chapter_4, unabhaengigkeit_erklaeren) -> % war: independence
        write('Kapitel 4: Du strebtest nach voller Unabhaengigkeit Aegyptens.')
    ;   write('Kapitel 4: Caesars Tod stellte dich vor neue Herausforderungen.')
    ), nl,

    % Kapitel 5 Analyse (Annahme: bereits erweitert)
    (   player_choice(chapter_5, verfuehrung_antonius) -> % war: seduce_antony
        write('Kapitel 5: Du bandest Antonius durch Verfuehrung an dich.')
    ;   player_choice(chapter_5, gleichberechtigte_partnerin) -> % war: equal_partner
        write('Kapitel 5: Du etabliertest ein Buendnis auf Augenhoehe mit Antonius.')
    ;   player_choice(chapter_5, unterwerfung) -> % war: submission
        write('Kapitel 5: Du unterwarfest dich der roemischen Macht.')
    ;   write('Kapitel 5: Dein Umgang mit Antonius bestimmte das Verhaeltnis zu Rom.')
    ), nl,

    % Kapitel 6 Analyse (Annahme: bereits erweitert)
    (   player_choice(chapter_6, endkampf) -> % war: final_battle
        write('Kapitel 6: Du stelltest dich dem Endkampf bei Actium.')
    ;   player_choice(chapter_6, flucht) -> % war: escape
        write('Kapitel 6: Du waehltest die Flucht, um Aegypten zu schuetzen.')
    ;   player_choice(chapter_6, kapitulation) -> % war: surrender
        write('Kapitel 6: Du kapituliertest vor Octavians Uebermacht.')
    ;   write('Kapitel 6: Die Schlacht von Actium war ein Wendepunkt.')
    ), nl,

    % Kapitel 7 Analyse (Annahme: bereits erweitert)
    (   player_choice(chapter_7, ehrenhafter_tod) -> % war: honorable_death
        write('Kapitel 7: Du waehltest einen ehrenhaften Tod als freie Pharaonin.')
    ;   player_choice(chapter_7, unterwerfung_rom) -> % war: submission_rome
        write('Kapitel 7: Du akzeptiertest das Schicksal der Gefangenschaft.')
    ;   player_choice(chapter_7, exil) -> % war: exile
        write('Kapitel 7: Du wagtest die Flucht ins Ungewisse.')
    ;   write('Kapitel 7: Deine letzte Entscheidung besiegelte dein Vermaechtnis.')
    ), nl,

    % Analyse egypt_status (Annahme: bereits erweitert)
    (   game_state(egypt_status, Status) ->
        (   write('Finaler Status Aegyptens: '), write(Status), write('. '), nl,
            % Detailliertere Analyse des Status basierend auf den deutschen Atomen
            (   Status == instabil -> write('Aegypten blieb bis zum Schluss instabil.')
            ;   Status == buergerkrieg -> write('Aegypten war am Ende noch im Buergerkrieg oder dessen unmittelbaren Folgen.')
            ;   Status == roemisch_geschuetzt -> write('Aegypten stand unter roemischem Schutz, war aber nicht unabhaengig.')
            ;   Status == stabil_beliebt -> write('Aegypten war innerlich stabil und du beim Volk beliebt.')
            ;   Status == stabil_durch_furcht -> write('Aegypten war innerlich stabil, aber durch Furcht regiert.')
            ;   Status == roemisch_verbuendet -> write('Aegypten war ein enger Verbuendeter Roms, aber abhaengig.')
            ;   Status == trotzige_unabhaengigkeit -> write('Aegypten behauptete eine trotzige Unabhaengigkeit gegenueber Rom.')
            ;   Status == gestaerkt_neutral -> write('Aegypten ging gestaerkt und neutral aus den Konflikten hervor.')
            ;   Status == unabhaengig_trotzig -> write('Aegypten erklaerte seine Unabhaengigkeit, was zu Spannungen mit Rom fuehrte.')
            ;   Status == unabhaengig_verbuendet -> write('Aegypten war unabhaengig, aber mit starken Verbuendeten.')
            ;   Status == roemische_provinz -> write('Aegypten wurde zu einer roemischen Provinz.')
            ;   Status == vasallenstaat_unter_caesarion -> write('Aegypten wurde ein Vasallenstaat unter Caesarion, kontrolliert von Rom.')
            ;   Status == roemische_provinz_endgueltig -> write('Aegypten wurde endgueltig eine roemische Provinz.')
            ;   Status == roemische_provinz_verhandelt -> write('Aegypten wurde nach Verhandlungen eine roemische Provinz.')
            ;   Status == ungewiss_nach_flucht -> write('Der Status Aegyptens nach deiner Flucht ist ungewiss.')
            ;   Status == roemische_provinz_gefangen -> write('Nach deiner Gefangennahme wurde Aegypten eine roemische Provinz.')
            ;   write('Der Status Aegyptens spiegelt deine politischen Entscheidungen wider.') % Fallback
            )
        )
    ;   write('Der finale Status Aegyptens konnte nicht bestimmt werden.')
    ), nl,

    % Analyse reputation (Annahme: bereits erweitert)
    (   game_state(reputation, Rep) ->
        write('Dein finaler Ruf: '), write(Rep), write('.'), nl,
        (   Rep == goettliche_pharaonin -> write('Du gingst als goettliche Herrscherin in die Geschichte ein.')
        ;   Rep == gefuerchtete_herrscherin -> write('Man erinnerte sich an dich als eine gefuerchtete Herrscherin.')
        ;   Rep == kultivierte_pharaonin -> write('Dein kulturelles Erbe und deine Bildung blieben unvergessen.')
        ;   Rep == listige_strategin -> write('Du warst bekannt fuer deine klugen und manchmal undurchsichtigen Plaene.')
        ;   Rep == starke_pharaonin -> write('Deine Staerke und dein unnachgiebiger Wille wurden zu deinem Markenzeichen.')
        ;   Rep == rechtmaessige_erbin -> write('Du hast deinen rechtmaessigen Anspruch geltend gemacht, doch das allein definierte nicht dein gesamtes Erbe.')
        ;   Rep == gedemuetigte_koenigin -> write('Dein Stolz wurde gebrochen, und du wurdest als gedemuetigte Koenigin in Erinnerung behalten.')
        ;   Rep == legende_im_exil -> write('Auch im Exil blieb deine Legende lebendig.')
        ;   Rep == mysterium_des_ostens -> write('Dein Verschwinden im Osten machte dich zu einem Mysterium.')
        ;   Rep == gefangene_koenigin -> write('Als Gefangene Roms endete deine Herrschaft, aber nicht deine Geschichte.')
        ;   write('Dein Ruf hallt durch die Zeiten.') % Fallback
        )
    ;   write('Dein finaler Ruf konnte nicht bestimmt werden.')
    ), nl,

    % Analyse popular_support (Annahme: bereits erweitert)
    (   game_state(popular_support, SupportValue) ->
        write('Volksunterstuetzung am Ende: '), write(SupportValue), write('%'), nl,
        (   SupportValue > 75 -> write('Das Volk liebte und verehrte dich ueber alle Massen.')
        ;   SupportValue > 50 -> write('Du hattest eine solide Unterstuetzung im Volk.')
        ;   SupportValue > 25 -> write('Die Unterstuetzung des Volkes war wechselhaft.')
        ;   write('Das Volk stand dir eher kritisch gegenueber.')
        )
    ;   write('Die finale Volksunterstuetzung konnte nicht bestimmt werden.')
    ), nl,

    % NEU: Analyse des Staatsschatzes
    (   game_state(treasury, FinalTreasury) ->
        write('Finanzen Aegyptens: '), write(FinalTreasury), write(' Einheiten im Staatsschatz.'), nl,
        (   FinalTreasury >= 100 ->
            write('Deine Finanzpolitik war aeusserst erfolgreich und hat Aegypten grossen Reichtum beschert.')
        ;   FinalTreasury >= 50 ->
            write('Die Staatsfinanzen sind solide, auch wenn einige Entscheidungen kostspielig waren.')
        ;   FinalTreasury > 0 ->
            write('Der Staatsschatz ist stark erschoepft, Aegypten steht vor finanziellen Herausforderungen.')
        ;   write('Aegypten ist praktisch bankrott. Die Staatskasse ist leer oder verschuldet.')
        )
    ;   write('Der Zustand der Staatsfinanzen konnte nicht bestimmt werden.')
    ), nl,

    (   player_choice(chapter_3, geheime_vorbereitung), game_state(geheime_vorbereitung, true) -> % war: secret_prep, secret_preparation
        write('Deine geheimen Vorbereitungen in Kapitel 3 zeugten von grosser Voraussicht.'), nl
    ;   true
    ).

% ================================================================
% HILFSPRAEDIKATE
% ================================================================

% Status anzeigen
show_status :-
    write('AKTUELLER STATUS:'), nl,
    game_state(chapter, C), write('Kapitel: '), write(C), nl,
    game_state(egypt_status, S), write('Aegypten: '), write(S), nl,
    game_state(reputation, R), write('Ruf: '), write(R), nl,
    (   game_state(popular_support, PS) -> % Pruefen, ob vorhanden
        write('Volksunterstuetzung: '), write(PS), write('/100'), nl
    ;   true % Nichts tun, falls nicht initialisiert
    ).

% Einfacher Start ohne Initialization-Direktive
:- write('==============================================='), nl,
   write('Kleopatra Adventure geladen!'), nl,
   write('Gib "start_game." ein, um zu beginnen!'), nl,
   write('==============================================='), nl.