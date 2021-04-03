% Appel de la librairie
:- use_module(library(pce)).
:- consult('regles.pl').

% Chargement des images
:- pce_image_directory('./assets/').


% Fonction pour la création d image
image(Fenetre, CheminImg, Image, Position) :-
	new(Image, image(CheminImg)),
	new(ImgBitmap, bitmap(Image,@on)),
	send(Fenetre, display, ImgBitmap, Position).

% Prédicat dynamique
:-dynamic image/4.
:-dynamic tour/1. % paramètre qui dit si c est un pion ou unmur // Return true or false si les coordonnées sont jouables
:-dynamic affichageAction/6. % Update du pion ou placement d un mur sur le plateau
:-dynamic finDuJeu/1. % return true or false si l action termine la partie
:-dynamic nbTours/1. % Compte le nb de tours
:-dynamic affichageJoueur/1. % Update affichage du joueur
:-dynamic deplacerPion/4.

:-dynamic(coordonnees/2).

coordonnees("P1",[1,5]).
coordonnees("P2",[9,5]).
coordonnees("BV",[]).
coordonnees("BH",[]).

:-dynamic(joueurActuel/1).
joueurActuel(1).

:-dynamic(nbBarriere/2).
nbBarriere(1,0).
nbBarriere(2,0).



% libération des ressources
liberer :-
	free(PionJ1),
	free(PionJ2),
	free(LabelJ1),
	free(LabelJ2),
	free(LabelMur),
	free(LabelPion),
	free(LabelHorizontal),
	free(Action),
	free(LabelCoord),
	free(Colonne),
	free(Ligne),
	free(Grille),
	free(PionJ1),
	free(Partie).


% Permet d afficher un menu d orientation
afficherOrientation(DialogGroup) :-
	send(DialogGroup, append, new(Orientation, menu(orientation, marked))),
	send(Orientation, append, horizontal),
	send(Orientation, append, vertical).


deplacerPion(CaseX, CaseY, G1, Pion) :-
	joueurActuel(1),
	coordonnees("P1",[X,Y]),
	%% IL FAUDRAIT SUPPRIMER L'IMAGE
	% NE FONCTIONNE PAS
	%send(Pion, destroy),
	%free(PionJ1),

	CX is CaseX-1,
	CY is CaseY-1,
	CoordX is 50 + CX * 52,
	CoordY is 47 + CY * 53,

	CNeutreX is X-1,
	CNeutreY is Y-1,
	CoordNeutreX is 48 + CNeutreX * 52,
	CoordNeutreY is 46 + CNeutreY * 53,

	image(G1, 'pionNeutre.jpg', PionNeutre, point(CoordNeutreY,CoordNeutreX)),
	image(G1, 'pionJ1.jpg', PionJ, point(CoordX, CoordY)).
	%send(Pion, point(500, 500)).

deplacerPion(CaseX, CaseY, G1, Pion) :-
	joueurActuel(2),
	coordonnees("P2",[X,Y]),
	%% IL FAUDRAIT SUPPRIMER L'IMAGE
	% NE FONCTIONNE PAS
	%send(Pion, destroy),
	%free(PionJ1),

	CX is CaseX-1,
	CY is CaseY-1,
	CoordX is 49 + CX * 52,
	CoordY is 48 + CY * 53,

	CNeutreX is X-1,
	CNeutreY is Y-1,
	CoordNeutreX is 55 + CNeutreX * 52,
	CoordNeutreY is 45 + CNeutreY * 53,

	image(G1, 'pionNeutre.jpg', PionNeutre, point(CoordNeutreY,CoordNeutreX)),
	image(G1, 'pionJ2.jpg', PionJ, point(CoordX, CoordY)).
	%send(Pion, point(500, 500)).

afficherMurHorizontal(CaseX, CaseY, G1, PionJ1) :-

	CX is CaseX-1,
	CY is CaseY-1,
	CoordX is 43 + CX * 52,
	CoordY is 85 + CY * 53,


	image(G1, 'murHorizontal.jpg', Temp, point(CoordX, CoordY)).

afficherMurVertical(CaseX, CaseY, G1, PionJ1) :-

	CX is CaseX-1,
	CY is CaseY-1,
	CoordX is 86 + CX * 52,
	CoordY is 41 + CY * 53,


	image(G1, 'murVertical.jpg', Temp, point(CoordX, CoordY)).

% Fonction qui permet d'afficher l'action
% Pour le pion
affichageAction(CaseX, CaseY, 'pion', G1, Pion, _) :-
	deplacerPion(CaseX, CaseY, G1, Pion).

% Pour le mur
% horizontal
affichageAction(CaseX, CaseY, 'mur', G1, Pion, 'horizontal') :-
	afficherMurHorizontal(CaseX, CaseY, G1, Pion).

% vertical
affichageAction(CaseX, CaseY, 'mur', G1, Pion, 'vertical') :-
	afficherMurVertical(CaseX, CaseY, G1, Pion).

% Initialise la partie
init :-
	% On libere les futures ressources utilisées
	liberer,

	% Création de la fenêtre de dialogue
	new(Partie, dialog('Partie du jeu Quoridor', size(800, 750))),

	% Création des dialgo group
	new(G1, dialog_group(' ')),
    new(G2, dialog_group(' ')),
	send(Partie, append, G1),
    send(Partie, append, G2, right),

	% Affichage de la grille
	image(G1, 'grille.jpg', Grille, point(0,0)),

	% Affichage des pions
	% J1
	image(G1, 'pionJ1.jpg', PionJ1, point(257,47)),

	% J2
	image(G1, 'pionJ2.jpg', PionJ2, point(257,472)),


	% Affichage des options de jeux
	% Labels
	send(G2, append, new(LabelJ1, text('Joueur 1'))),
	send(G2, append, new(LabelJ2, text('Joueur 2'))),
	% radio buttons
	send(G2, append, new(Action, menu(action, marked))),
	send(Action, append, pion),
	send(Action, append, mur),

	send(G2, append, new(Orientation, menu(orientation, marked))),
	send(Orientation, append, horizontal),
	send(Orientation, append, vertical),

	% Text input
	send(G2, append, new(Colonne, text_item('Entrer la colonne'))),
	send(G2, append, new(Ligne, text_item('Entrer la ligne'))),

	% Bouton de validation
	send(G2,append,
		button(valider, message(@prolog, submit,
								Colonne?selection,
								Ligne?selection,
								Action?selection,
								G1,
								PionJ1,
								Orientation?selection
								))),

	% On ouvre la fenêtre de dialogue
	send(Partie, open).

:-init.


%submit(Colonne, Ligne, Action, G1, Pion, Orientation)
submit(Colonne, Ligne, 'pion', G1, Pion, Orientation) :-
	joueurActuel(1),

	% Convertit une chaine de caractères en int
	atom_number(Colonne, X),
	atom_number(Ligne, Y),

	coordonnees("P1",[X1,Y1]),
	coordonnees("P2",[X2,Y2]),
	coordonnees("BH",LH),
	coordonnees("BV",LV),


	\+jeuTermine([X1,Y1], [X2,Y2]),


	tour([X1,Y1],[X2,Y2],LH, LV,"P1", [Y,X]),

	affichageAction(X, Y, 'pion', G1, Pion, Orientation),

	retract(coordonnees("P1",_)),
	assertz(coordonnees("P1",[Y,X])),

	retract(joueurActuel(1)),
	assertz(joueurActuel(2)).

submit(Colonne, Ligne, 'pion', G1, Pion, Orientation) :-
	joueurActuel(2),

	% Convertit une chaine de caractères en int
	atom_number(Colonne, X),
	atom_number(Ligne, Y),

	coordonnees("P1",[X1,Y1]),
	coordonnees("P2",[X2,Y2]),
	coordonnees("BH",LH),
	coordonnees("BV",LV),

	\+jeuTermine([X1,Y1], [X2,Y2]),

	tour([X1,Y1],[X2,Y2],LH, LV,"P2", [Y,X]),

	affichageAction(X, Y, 'pion', G1, Pion, Orientation),

	retract(coordonnees("P2",_)),
	assertz(coordonnees("P2",[Y,X])),

	retract(joueurActuel(2)),
	assertz(joueurActuel(1)).

submit(Colonne, Ligne, 'mur', G1, Pion, 'vertical') :-
	joueurActuel(IDJoueur),
	nbBarriere(IDJoueur,NB),
	NB < 10,

	% Convertit une chaine de caractères en int
	atom_number(Colonne, X),
	atom_number(Ligne, Y),

	coordonnees("P1",[X1,Y1]),
	coordonnees("P2",[X2,Y2]),
	coordonnees("BH",LH),
	coordonnees("BV",LV),

	\+jeuTermine([X1,Y1], [X2,Y2]),

	tour([X1,Y1],[X2,Y2],LH, LV,"BV", [Y,X]),
	affichageAction(X, Y, 'mur', G1, Pion, 'vertical'),

	retract(coordonnees("BV",_)),
	assertz(coordonnees("BV",[Y|[X|LV]])),

	retract(nbBarriere(IDJoueur,_)),
	NewNBBarriere is NB +1,
	assertz(nbBarriere(IDJoueur,NewNBBarriere)),

	retract(joueurActuel(IDJoueur)),
	NewIDJoueur is 3-IDJoueur,
	assertz(joueurActuel(NewIDJoueur)).

submit(Colonne, Ligne, 'mur', G1, Pion, 'horizontal') :-
	joueurActuel(IDJoueur),
	nbBarriere(IDJoueur,NB),
	NB < 10,

	% Convertit une chaine de caractères en int
	atom_number(Colonne, X),
	atom_number(Ligne, Y),

	coordonnees("P1",[X1,Y1]),
	coordonnees("P2",[X2,Y2]),
	coordonnees("BH",LH),
	coordonnees("BV",LV),
	
	\+jeuTermine([X1,Y1], [X2,Y2]),

	tour([X1,Y1],[X2,Y2],LH, LV,"BH", [Y,X]),

	affichageAction(X, Y, 'mur', G1, Pion, 'horizontal'),

	retract(coordonnees("BH",_)),
	asserta(coordonnees("BH",[Y|[X|LH]])),

	retract(nbBarriere(IDJoueur,_)),
	NewNBBarriere is NB +1,
	assertz(nbBarriere(IDJoueur,NewNBBarriere)),

	retract(joueurActuel(IDJoueur)),
	NewIDJoueur is 3-IDJoueur,
	assertz(joueurActuel(NewIDJoueur)).

% Fin de fichier
