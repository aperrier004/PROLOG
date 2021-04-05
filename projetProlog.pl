%%% PROJET PROLOG - Jeu du Quoridor
%%% ENSC 2A - 2021
%%% Auteurs : GADEAU Juliette - GUERIN Élisa - PERRIER ALBAN - THOMAS Énora - THOMASSON Lucie

% Fichier main permettant de jouer au jeu sur une interface graphique

% Permet de ne pas afficher les warning de singleton variable ou discontigous
:- style_check(-singleton).
:- style_check(-discontiguous).

%%------------------------------------CHARGEMENT DES RESSOURCES------------------------------------------%%
% Appel de la librairie XPCE
:- use_module(library(pce)).
% On charge le fichier de regles du jeu
:- consult('regles.pl').

% Chargement des images
:- pce_image_directory('./assets/').

%%------------------------------------PRÉDICATS------------------------------------------%%
% Prédicats dynamique
:-dynamic image/4. % prédicat pour créer une image
:-dynamic affichageAction/6. % Update du pion ou placement d une barriere sur le plateau
:-dynamic deplacerPion/4.

% Prédicats pour garder en mémoire des données
% Coordonées
:-dynamic(coordonnees/2).
% Du Joueur/Pion 1
coordonnees("P1",[1,5]).
% Du Joueur/Pion 2
coordonnees("P2",[9,5]).
% Des barrières verticales sur le plateau
coordonnees("BV",[]).
% Des barrières horizontales sur le plateau
coordonnees("BH",[]).

% Stocke le joueur qui doit joueur
:-dynamic(joueurActuel/1).
joueurActuel(1).

% Stocke le nombre de barrières restantes pour chaque joueur
:-dynamic(nbBarriere/2).
% J1
nbBarriere(1,0).
% J2
nbBarriere(2,0).



% Libération des ressources
liberer :-
	free(coordonees),
	free(nbBarriere),
	free(Partie).

% Prédicat pour la création d image
image(Fenetre, CheminImg, Image, Position) :-
	% On cree une image a partir d'un chemin
	new(Image, image(CheminImg)),
	% On convertit cette image en bitmap
	new(ImgBitmap, bitmap(Image,@on)),
	% On envoie la bitmap sur une fenetre
	send(Fenetre, display, ImgBitmap, Position).

% Predicat pour afficher une fenetre lorsque la partie est terminee
afficherFinDePartie :-
	% On recupere les coordonees des joueurs 1 et 2
	coordonnees("P1",[X1,Y1]),
	coordonnees("P2",[X2,Y2]),
	
	% On regarde si l'un des deux a termine
	jeuTermine([X1,Y1], [X2,Y2]),

	% SI TRUE
	% Alors on affiche une fenetre de fin de jeu
	new(Fin, dialog('FIN DU JEU', size(500, 500))),
	new(G, dialog_group('Fin de partie !')),
	send(Fin, append, G),
	send(G, append, new(Label, text('La partie est terminee ! Veuillez quittez l\'application pour relancer une partie'))),
	send(Fin, open).

% Predicat pour afficher une fenetre indiquant le debut d'un tour pour un joueur
afficherTour :-
	% On recupere le joueur qui doit jouer
	joueurActuel(J),
	% On recupere le nombre de barriere qu'il a posee
	nbBarriere(J,NbBarriere),
	% Calcul du nombre de barrieres restantes
	BarrieresRestantes is 10 - NbBarriere,

	% Conversion d'un int en string
	number_string(BarrieresRestantes, BarriereString),
	number_string(J, JString),

	% Pour un affichage explicit
	string_concat('Nombre de barrieres restants : ', BarriereString, LabelBarriere),
	string_concat('C\'est au tour du joueur : ', JString, LabelJoueur),

	% Creation de la fenetre
	new(BarriereFenetre, dialog('TOUR', size(1000,1000))),
	new(BarriereDlg, dialog_group('Informations du tour :')),
	send(BarriereFenetre, append, BarriereDlg),
	send(BarriereDlg, append, new(Joueur, text(LabelJoueur))),
	send(BarriereDlg, append, new(Barriere, text(LabelBarriere))),

	send(BarriereFenetre, open).

% Predicat pour afficher une fenetre d'erreur
affichageErreur :-
	% Creation de la fenetre
	new(ErreurFenetre, dialog('ERREUR', size(1000,1000))),
	new(ErreurDlg, dialog_group('Erreur :')),
	send(ErreurFenetre, append, ErreurDlg),
	send(ErreurDlg, append, new(Joueur, text('L\'action ne peut pas etre realisee, veuillez recommencez'))),

	send(ErreurFenetre, open).

% Predicat pour simuler le mouvement du pion pour le Joueur 1
deplacerPion(CaseX, CaseY, G1, Pion) :-
	% SI c'est au tour du joueur 1
	joueurActuel(1),
	% On recupere ses coordonees
	coordonnees("P1",[X,Y]),
	% On opere des calculs pour placer sur l'interface en pixels
	% Calcul pour le nouveau pion
	CX is CaseX-1,
	CY is CaseY-1,
	CoordX is 50 + CX * 52,
	CoordY is 47 + CY * 53,

	% Calcul pour le pion qui cache celui actuel
	CNeutreX is X-1,
	CNeutreY is Y-1,
	CoordNeutreX is 48 + CNeutreX * 52,
	CoordNeutreY is 46 + CNeutreY * 53,

	% On affiche un pion neutre pour cacher l'ancien
	image(G1, 'pionNeutre.jpg', PionNeutre, point(CoordNeutreY,CoordNeutreX)),
	% On affiche un nouveau pion pour simuler un deplacement
	image(G1, 'pionJ1.jpg', PionJ, point(CoordX, CoordY)).

% Predicat pour simuler le mouvement du pion pour le Joueur 2
deplacerPion(CaseX, CaseY, G1, Pion) :-
	% SI c'est au tour du joueur 2
	joueurActuel(2),
	% On recupere ses coordonees
	coordonnees("P2",[X,Y]),
	% On opere des calculs pour placer sur l'interface en pixels
	% Calcul pour le nouveau pion
	CX is CaseX-1,
	CY is CaseY-1,
	CoordX is 49 + CX * 52,
	CoordY is 48 + CY * 53,

	% Calcul pour le pion qui cache celui actuel
	CNeutreX is X-1,
	CNeutreY is Y-1,
	CoordNeutreX is 55 + CNeutreX * 52,
	CoordNeutreY is 45 + CNeutreY * 53,

	% On affiche un pion neutre pour cacher l'ancien
	image(G1, 'pionNeutre.jpg', PionNeutre, point(CoordNeutreY,CoordNeutreX)),
	% On affiche un nouveau pion pour simuler un deplacement
	image(G1, 'pionJ2.jpg', PionJ, point(CoordX, CoordY)).

% Predicat pour afficher une barriere horizontale sur la grille
afficherBarriereHorizontale(CaseX, CaseY, G1, PionJ1) :-
	% Calcul des coordonees en pixel
	CX is CaseX-1,
	CY is CaseY-1,
	CoordX is 43 + CX * 52,
	CoordY is 85 + CY * 53,

	% On affiche la barriere horizontale
	image(G1, 'barriereHorizontale.jpg', BH, point(CoordX, CoordY)).

% Predicat pour afficher une barriere verticale sur la grille
afficherBarriereVerticale(CaseX, CaseY, G1, PionJ1) :-
	% Calcul des coordonees en pixel
	CX is CaseX-1,
	CY is CaseY-1,
	CoordX is 86 + CX * 52,
	CoordY is 41 + CY * 53,

	% On affiche la barriere verticale
	image(G1, 'barriereVerticale.jpg', BV, point(CoordX, CoordY)).

% Predicat qui permet d'afficher l'action
% Pour le pion
affichageAction(CaseX, CaseY, 'pion', G1, Pion, _) :-
	deplacerPion(CaseX, CaseY, G1, Pion).

% Pour la barriere
% horizontale
affichageAction(CaseX, CaseY, 'barriere', G1, Pion, 'horizontale') :-
	afficherBarriereHorizontale(CaseX, CaseY, G1, Pion).

% verticale
affichageAction(CaseX, CaseY, 'barriere', G1, Pion, 'verticale') :-
	afficherBarriereVerticale(CaseX, CaseY, G1, Pion).

% Initialisation de la partie
init :-
	% On libere les futures ressources utilisées
	liberer,

	% Création de la fenêtre de dialogue
	new(Partie, dialog('Partie du jeu Quoridor', size(800, 750))),

	% Création des dialog group
	% G1 --> Dialog group de la grile
	new(G1, dialog_group(' ')),
	% G2 --> Dialog group des informations et permet de joueur
    new(G2, dialog_group(' ')),
	send(Partie, append, G1),
	% On place le G2 a droite
    send(Partie, append, G2, right),

	% Affichage de la grille
	image(G1, 'grille.jpg', Grille, point(0,0)),
	% Affichage des pions
	% J1
	image(G1, 'pionJ1.jpg', PionJ1, point(257,47)),
	% J2
	image(G1, 'pionJ2.jpg', PionJ2, point(257,472)),

	% Affichage des options de jeux
	% radio buttons 
	% Action : Soit on deplace un pion, soit on place une barriere
	send(G2, append, new(Action, menu(action, marked))),
	send(Action, append, pion),
	send(Action, append, barriere),

	% Permet de choisir l'orientation d'une barriere
	send(G2, append, new(Orientation, menu(orientation, marked))),
	send(Orientation, append, horizontale),
	send(Orientation, append, verticale),

	% Text input pour recuperer les coordonees entree
	send(G2, append, new(Ligne, text_item('Entrer la ligne'))),
	send(G2, append, new(Colonne, text_item('Entrer la colonne'))),

	% Bouton de validation pour joueur
	
	send(G2,append,
	% On cree un bouton, avec pour libelle "valider" et sur lequel on appellera le predicat "submit" a chaque fois que le bouton sera clique
		button(valider, message(@prolog, submit,
								% permet de recuperer la valeur entree par l'utilisateur
								Colonne?selection,
								Ligne?selection,
								% permet de recuperer ce qui a ete cochee
								Action?selection,
								% On transmet le Dialog group pour afficher des elements dessus plus tard
								G1,
								PionJ1,
								Orientation?selection
								))),

	% Texte d'explication pour l'exemple
	send(G2, append, new(ExplicationPion, text('Le pion vert correspond au Joueur 1 et le rouge au Joueur 2'))),
	send(G2, append, new(Explication, text('Exemple de positionnement de barriere : (10 max par joueur)'))),
	send(G2,append, new(Explication2, text('Ici, la barriere verticael est en (1,1) et le barriere horizontale en (3,2).'))),
	% image d'exemple
	image(G2, 'grilleExemple.jpg', Exemple, point(60,260)),
	
	% On ouvre la fenêtre de dialogue
	send(Partie, open),
	% On appelle afficherTour pour indiquer des informations
	afficherTour.

% On appelle le predicat init pour lancer la partie
:-init.

% Predicat qui permet de verifier quel joueur joue, si son action est possible en terme de coordonee
% Et qui va afficher le resultat en consequence

% Si on a selectionee "pion" et qu'on est le joueur 1
submit(Colonne, Ligne, 'pion', G1, Pion, Orientation) :-
%submit(Colonne, Ligne, Action, G1, Pion, Orientation)
	% Verif si c'est le joueur 1
	joueurActuel(1),

	% Convertit une chaine de caractères en int
	atom_number(Colonne, X),
	atom_number(Ligne, Y),

	% Recuperation des coordonees de nos variables
	coordonnees("P1",[X1,Y1]),
	coordonnees("P2",[X2,Y2]),
	coordonnees("BH",LH),
	coordonnees("BV",LV),

	% Si le jeu n'est pas terminé
	\+jeuTermine([X1,Y1], [X2,Y2]),
	% Alors on verifie si l'action et les coordonees sont possible
	tour([X1,Y1],[X2,Y2],LH, LV,"P1", [Y,X]),

	% Si TRUE, alors on affiche l'action 
	affichageAction(X, Y, 'pion', G1, Pion, Orientation),

	% On supprime la derniere position du pion
	retract(coordonnees("P1",_)),
	% On ajoute une nouvelle
	assertz(coordonnees("P1",[Y,X])),

	% Le joueur qui doit jouer s'inverse
	retract(joueurActuel(1)),
	assertz(joueurActuel(2)),

	afficherTour,
	
	% On appelle afficherFinDePartie qui va verifie si la partie est terminee ou pas, et faire les affichages correspondants
	!,afficherFinDePartie.

% Si on a selectionee "pion" et qu'on est le joueur 2
submit(Colonne, Ligne, 'pion', G1, Pion, Orientation) :-
	% Verif si c'est le joueur 2
	joueurActuel(2),

	% Convertit une chaine de caractères en int
	atom_number(Colonne, X),
	atom_number(Ligne, Y),
	
	% Recuperation des coordonees de nos variables
	coordonnees("P1",[X1,Y1]),
	coordonnees("P2",[X2,Y2]),
	coordonnees("BH",LH),
	coordonnees("BV",LV),

	% Si le jeu n'est pas terminé
	\+jeuTermine([X1,Y1], [X2,Y2]),
	% Alors on verifie si l'action et les coordonees sont possible
	tour([X1,Y1],[X2,Y2],LH, LV,"P2", [Y,X]),

	% Si TRUE, alors on affiche l'action 
	affichageAction(X, Y, 'pion', G1, Pion, Orientation),

	% On supprime la derniere position du pion
	retract(coordonnees("P2",_)),
	% On ajoute une nouvelle
	assertz(coordonnees("P2",[Y,X])),

	% Le joueur qui doit jouer s'inverse
	retract(joueurActuel(2)),
	assertz(joueurActuel(1)),

	afficherTour,

	% On appelle afficherFinDePartie qui va verifie si la partie est terminee ou pas, et faire les affichages correspondants
	!,afficherFinDePartie.

% Si on a selectionee "barriere" et "verticale"
submit(Colonne, Ligne, 'barriere', G1, Pion, 'verticale') :-
	% On recupere le joueur qui doit joueur
	joueurActuel(IDJoueur),
	% On recupere le nombre de barriere qu'il a joue
	nbBarriere(IDJoueur,NB),

	% Ce nombre doit etre inferieur a 10
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
	affichageAction(X, Y, 'barriere', G1, Pion, 'verticale'),

	retract(coordonnees("BV",_)),
	assertz(coordonnees("BV",[Y|[X|LV]])),

	% On ajoute une barriere de jouee 
	retract(nbBarriere(IDJoueur,_)),
	NewNBBarriere is NB +1,
	assertz(nbBarriere(IDJoueur,NewNBBarriere)),

	% On intervertit le joueur
	retract(joueurActuel(IDJoueur)),
	NewIDJoueur is 3-IDJoueur,
	assertz(joueurActuel(NewIDJoueur)),
	
	afficherTour,

	!,afficherFinDePartie.

submit(Colonne, Ligne, 'barriere', G1, Pion, 'horizontale') :-
	% On recupere le joueur qui doit joueur
	joueurActuel(IDJoueur),
	% On recupere le nombre de barriere qu'il a joue
	nbBarriere(IDJoueur,NB),

	% Ce nombre doit etre inferieur a 10
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

	affichageAction(X, Y, 'barriere', G1, Pion, 'horizontale'),

	retract(coordonnees("BH",_)),
	asserta(coordonnees("BH",[Y|[X|LH]])),

	% On ajoute une barriere de jouee 
	retract(nbBarriere(IDJoueur,_)),
	NewNBBarriere is NB +1,
	assertz(nbBarriere(IDJoueur,NewNBBarriere)),

	% On intervertit le joueur
	retract(joueurActuel(IDJoueur)),
	NewIDJoueur is 3-IDJoueur,
	assertz(joueurActuel(NewIDJoueur)),

	afficherTour,
	
	!,afficherFinDePartie.

% Predicat submit qui permet d'afficher une erreur dans le cas ou les predicat precedents auraient renvoye FALSE
% Par exemple si les coordonees rentrees ne sont pas bonne et que le predicat tour retourn FALSE
submit(_,_,_,_,_,_) :-
	affichageErreur.

% Fin de fichier
