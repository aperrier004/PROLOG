% Appel de la librairie
:- use_module(library(pce)).

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
:-dynamic deplacerPion/5.



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

% Permet d'identifier le numero d'un joueur avec son image du pion
identification_Joueur(PionJ1, 1).
identification_Joueur(PionJ2, 2).

% Permet d afficher un menu d orientation
afficherOrientation(DialogGroup) :-
	send(DialogGroup, append, new(Orientation, menu(orientation, marked))),
	send(Orientation, append, horizontal),
	send(Orientation, append, vertical).


deplacerPion(CaseX, CaseY, IDJoueur, G1, Pion) :-
	%% DEBUG
	format('nb Jouueur  ~w ~n',
           [IDJoueur]),
	
	identification_Joueur(Pion, IDJoueur),

	%% DEBUG
	format('nb Jouueur ~w Pion ~w ~n',
           [IDJoueur, Pion]),


	%% IL FAUDRAIT SUPPRIMER L'IMAGE
	% NE FONCTIONNE PAS
	%send(Pion, destroy),
	%free(PionJ1),

	

	% Convertit une chaine de caractères en int
	atom_number(CaseX, X),
	atom_number(CaseY, Y),
	%% DEBUG
	format('X ~d Y ~d ~n',
		[X, Y]),

	CX is X-1,
	CY is Y-1,
	CoordX is 50 + CX * 52,
	CoordY is 47 + CY * 53,

	%% DEBUG
	format('CoordX ~w CoordY ~w ~n',
           [CoordX, CoordY]),

	image(G1, 'pionJ1.jpg', PionJ, point(CoordX, CoordY)).
	%send(Pion, point(500, 500)).

afficherMurHorizontal(CaseX, CaseY, IDJoueur, G1, PionJ1) :-
	%% DEBUG
	format('mur H  ~w ~n',
           [IDJoueur]),

	% Convertit une chaine de caractères en int
	atom_number(CaseX, X),
	atom_number(CaseY, Y),

	CX is X-1,
	CY is Y-1,
	CoordX is 38 + CX * 52,
	CoordY is 85 + CY * 53,


	image(G1, 'murHorizontal.jpg', Temp, point(CoordX, CoordY)).

afficherMurVertical(CaseX, CaseY, IDJoueur, G1, PionJ1) :-
	%% DEBUG
	format('mur V  ~w ~n',
           [IDJoueur]),

	% Convertit une chaine de caractères en int
	atom_number(CaseX, X),
	atom_number(CaseY, Y),

	CX is X-1,
	CY is Y-1,
	CoordX is 87 + CX * 52,
	CoordY is 37 + CY * 53,


	image(G1, 'murVertical.jpg', Temp, point(CoordX, CoordY)).

% Fonction qui permet d'afficher l'action
% Pour le pion
affichageAction(CaseX, CaseY, 'pion', IDJoueur, G1, Pion, _) :-
	format('Action?selection ~w CaseX ~w CaseY ~w Pion ~w ~n',
           ['pion', CaseX, CaseY, IDJoueur]),
	
	deplacerPion(CaseX, CaseY, IDJoueur, G1, Pion).

% Pour le mur
% horizontal
affichageAction(CaseX, CaseY, 'mur', IDJoueur, G1, Pion, 'horizontal') :-
	afficherMurHorizontal(CaseX, CaseY, IDJoueur, G1, Pion).

% vertical
affichageAction(CaseX, CaseY, 'mur', IDJoueur, G1, Pion, 'vertical') :-
	afficherMurVertical(CaseX, CaseY, IDJoueur, G1, Pion).

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
	image(G1, 'pionJ1.jpg', PionJ1, point(50,47)),

	% J2
	image(G1, 'pionJ2.jpg', PionJ2, point(102,99)),

	
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
		button(valider, message(@prolog, affichageAction,
								Colonne?selection,
								Ligne?selection,
								Action?selection,
								1,
								G1,
								PionJ1,
								Orientation?selection))),

	% On ouvre la fenêtre de dialogue
	send(Partie, open).
:-init.

% Fin de fichier