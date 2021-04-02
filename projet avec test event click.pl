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
:-dynamic tour/1. % paramètre qui dit si c est un pion ou unmur // Return true or false si les coordonnées sont jouables
:-dynamic affichageAction/1. % Update du pion ou placement d un mur sur le plateau
:-dynamic finDuJeu/1. % return true or false si l action termine la partie
:-dynamic nbTours/1. % Compte le nb de tours
:-dynamic affichageJoueur/1. % Update affichage du joueur

% libération des ressources
liberer :- 
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


%%%% A VOIR SI ON GARDE
% Permet d afficher un menu d orientation
afficherOrientation(DialogGroup) :-
	send(DialogGroup, append, new(Orientation, menu(orientation, marked))),
	send(Orientation, append, horizontal),
	send(Orientation, append, vertical).

afficherOrientation(mur,DialogGroup) :-!,
	send(DialogGroup, append, new(Orientation, menu(orientation, marked))),
	send(Orientation, append, horizontal),
	send(Orientation, append, vertical).

% Prédicat pour dire qu on ne peut pas choisir l orientation avec un pion
afficherOrientation(pion,_).

% A VOIR
estMur(DialogGroup, Choix) :-
	% On appelle le prédicat pour afficher ou non le choix d orientation du mur
    afficherOrientation(Choix,G2).
%%%%%

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
	image(G1, 'pionJ1.jpg', PionJ1, point(20,20)),
	% J2
	image(G1, 'pionJ2.jpg', PionJ2, point(100,100)),
	
	% Affichage des options de jeux
	% Labels
	send(G2, append, new(LabelJ1, text('Joueur 1'))),
	send(G2, append, new(LabelJ2, text('Joueur 2'))),
	% radio buttons
	send(G2, append, new(Action, menu(action, marked))),
	send(Action, append, pion),
	send(Action, append, mur),

	% Affichage de l orientation
	send(DialogGroup, append, new(Orientation, menu(orientation, marked))),
	send(Orientation, append, horizontal),
	send(Orientation, append, vertical),

	% Permet de créer un bouton "create" qui quand on click appelle le prédicat estMur
	% send(G2, append, button(create, message(@prolog, estMur,G2, Action?selection))),

	% Text input
	send(G2, append, new(Colonne, text_item('Entrer la colonne'))),
	send(G2, append, new(Ligne, text_item('Entrer la ligne'))),

	% Bouton de validation
	send(G2,append, button(valider)),

	% Code inutile pour l instant
	% Joueur 1
	%image(G2, 'lbl_J1.jpg', LabelJ1, point(750,100)),
	% Joueur 2
	%image(G2, 'lbl_J2.jpg', LabelJ2, point(750,150)),

	% Mur
	%image(G2, 'lbl_mur.jpg', LabelMur, point(800,200)),
	% Pion
	%image(G2, 'lbl_pion.jpg', LabelPion, point(850,200)),
	% Horizontal
	%image(G2, 'lbl_horizontal.jpg', LabelHorizontal, point(800,300)),
	% Vertical
	%image(G2, 'lbl_vertical.jpg', LabelVertical, point(850,300)),
	% Coordonnées
	%image(G2, 'lbl_coord.jpg', LabelCoord, point(800,400)),
	% Colonne
	%image(G2, 'lbl_col.jpg', LabelCol, point(750,450)),
	% Ligne
	%image(G2, 'lbl_ligne.jpg', LabelLigne, point(750,500)),
	% Bouton valider


	% On ouvre la fenêtre de dialogue
	send(Partie, open).
:-init.


% On garde au cas ou
estMur2(DialogGroup, Action) :-
	% on récupère le choix avec get
    get(Action, selection, Choix),
	% On appelle le prédicat pour afficher ou non le choix d orientation du mur
    afficherOrientation(Choix,G2).

% Fin de fichier