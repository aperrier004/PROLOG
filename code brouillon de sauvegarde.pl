create_person_dialog :-
	new(D, dialog('Enter new person')),
	send(D, append, new(label)),	% for reports
	send(D, append, new(Name, text_item(name))),
	send(D, append, new(Age, text_item(age))),
	send(D, append, new(Sex, menu(sex, marked))),

	send(Sex, append, female),
	send(Sex, append, male),
	send(Age, type, int),

	send(D, append,
			button(create, message(@prolog, create_person,
								Name?selection,
								Age?selection,
								Sex?selection))),

	send(D, default_button, create),
	send(D, open).

create_person(Name, Age, Sex) :-
	format('Creating ~w person ~w of ~d years old~n',
			[Sex, Name, Age]).

:-create_person_dialog.


% Appel de la librairie
:- use_module(library(pce)).

% Chargement des images
:- pce_image_directory('./assets/').

% Initialisation des images ressources
% resource(Name, fileSpec, option)
resource(grille,image, image('grille.jpg')).
resource(pionJ1,image, image('pionVert.jpg')).
resource(pionJ2,image, image('pionRouge.jpg')).
resource(barreJ,image, image('joueurActuel.jpg')).


% Prédicat dynamique
:-dynamic tour/1. % paramètre qui dit si c est un pion ou unmur // Return true or false si les coordonnées sont jouables
:-dynamic affichageAction/1. % Update du pion ou placement d un mur sur le plateau
:-dynamic finDuJeu/1. % return true or false si l action termine la partie
:-dynamic nbTours/1. % Compte le nb de tours
:-dynamic affichageJoueur/1. % Update affichage du joueur


% Initialisation d une partie

init:-
	retractall(tour(_)),
	assert(tour(1)),
	retractall(affichageAction(_)),
	assert(affichageAction(1)),
	retractall(finDuJeu(_)),
	assert(finDuJeu(1)),
	retractall(nbTours(_)),
	assert(nbTours(1)),
	retractall(affichageJoueur(_)),
	assert(affichageJoueur(1)),

% libération des ressources

liberer :- 
	free(@grilleBase),
	free(@carreBlanc),
	free(@pion1),
	free(@pion2).


init :- 
% Ouverture de la fenetre
	new(@fenetre, picture('Corridor')),
	send(@fenetre, open),
	liberer,
	% Création de la grille grise
	send(@fenetre, display, new(@grilleBase, box(500,500))),
	send(@grilleBase, fill_pattern, colour(grey)),
	% création de la case blanche
	send(@fenetre, display, new(@carreBlanc, box(30,30)), point(10,10)),
	send(@carreBlanc, fill_pattern, colour(white)),
	% Création des pions
	send(@fenetre, display, new(@pion1, circle(30)), point(10,10)),
	send(@pion1,fill_pattern, colour(blue)),
	send(@fenetre, display, new(@pion2, circle(30)), point(100,100)),
	send(@pion2,fill_pattern, colour(red)).


%% il faut mettre un :- pour éxecuter (vrai si..)
:- init.



% TODO :
% Essayer de faire un for sur les cases blanches, essayer "repeat"
% Voir pouur la taille et position des cases pour que ce soit réparti
% Fin de fichier