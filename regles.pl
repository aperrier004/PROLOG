%%% PROJET PROLOG - Jeu du Quoridor
%%% ENSC 2A - 2021
%%% Auteurs : GADEAU Juliette - GUERIN Élisa - PERRIER ALBAN - THOMAS Énora - THOMASSON Lucie

%%% Fichier rassemblant l'ensemble des règles utile au jeu

%%La partie interface nous donne les paramètres avec les positions de tout et ce que le joueur veut faire

%%-----------------------POSSIBILITE DE PLACER UN PION OU UNE BARRIERE------------------
%true si on peut placer un pion ou une barrière à l'endroit demandé
%tour(PositionJ1, PositionJ2, BarrieresH, BarrieresV, TypeAction, NewPosition)
tour(PositionJ1, PositionJ2, BarrieresH, BarrieresV, "P1", NewPosition) :- accessiblePion(Position1, NewPosition, BarrieresH, BarrieresV, Position2).
tour(PositionJ1, PositionJ2, BarrieresH, BarrieresV, "P2", NewPosition) :- accessiblePion(Position2, NewPosition, BarrieresH, BarrieresV, Position1).
tour(PositionJ1, PositionJ2, BarrieresH, BarrieresV, "BV", NewPosition) :- accessibleBarrieresV(NewPosition, BarrieresH, BarrieresV).
tour(PositionJ1, PositionJ2, BarrieresH, BarrieresV, "BH", NewPosition) :- accessibleBarrieresH(NewPosition, BarrieresH, BarrieresV).

%%------------------------------------------------------------------------------
%%ACCESSIBILITE POUR LE DEPLACEMENT D'UN PION

%true si 2 positions sont confondues
%memePosition([X1,Y1],[X2,Y2])
memePosition([X1,Y1],[X1,Y1]).

%true si la position voulue est sur le plateau et non confondue avec la position de l'adversaire
%validePositionPion(PositionVoulue,PositionAdversaire)
validePositionPion([X,Y],[Xadv,Yadv]) :- X>0 , X<10 , Y>0 , Y<10 , \+memePosition([X,Y],[Xadv,Yadv]).

%%------------------------------------------------------------------------------
%%POUR UN DEPLACEMENT VERTICAL

%true si le déplacement voulu est vertical et à proximité
%deplacementVertical([X1,Y1],[X2,Y2])
deplacementVertical([X1,Y1],[X2,Y1]) :- X1 is X2+1.   %vers le bas
deplacementVertical([X1,Y1],[X2,Y1]) :- X1 is X2-1.   %vers le haut

%tests d'alignements horizontal
%alignementHorizontalBarriereHorizontale(BY,Y)
alignementHorizontalBarriereHorizontale(BY,BY).   %le "début" de la barrière nous bloque
alignementHorizontalBarriereHorizontale(BY,Y) :- BY is Y-1.   %la "fin" de la barrière nous bloque

%tests d'alignements vertical
%alignementVerticalBarriereHorizontale(BX,X1,X2)
alignementVerticalBarriereHorizontale(BX,BX,X2) :- X2>BX.   %barrière en dessous pour un déplacement vers le bas
alignementVerticalBarriereHorizontale(BX,X1,BX) :- X1>BX.   %barrière au dessus pour un déplacement vers le haut

%false s'il y a une barrière horizontale qui nous bloque
%accessiblePionBarrieresH(PositionActuelle, PositionVoulue, BarrieresH, nbBarrièresBloquant)
accessiblePionBarrieresH(_, _, [], 0).    %plus aucune barrière nous bloque et aucune des précédentes non plus (Acc=0) donc c'est bon
accessiblePionBarrieresH([X1,Y1], [X2,Y2], [BX|[BY|Q]], Acc) :-   %cas où il y a une barrière qui nous embête
  alignementHorizontalBarriereHorizontale(BY,Y1) ,
  alignementVerticalBarriereHorizontale(BX,X1,X2) ,
  !,    %permet d'éviter le redo car on va arriver à accessiblePionBarrieresH(_, _, [], Acc) avec Acc>0 ce qui entraine une sortie false (c'est ce qu'on veut car une barrière nous empêche de passer)
  accessiblePionBarrieresH([X1,Y1], [X2,Y2], Q, Acc+1).
accessiblePionBarrieresH(PositionActuelle, PositionVoulue, [_|[_|Q]], Acc) :- accessiblePionBarrieresH(PositionActuelle, PositionVoulue, Q, Acc).   %la barrière "courante" ne pose pas de problème donc on regarde les suivantes

%true si le déplacement voulu est réalisable (et vertical)
%accessiblePion([X1,Y1], [X2,Y2], BarrieresH, BarrieresV, [Xadv,Yadv])
accessiblePion([X1,Y1], [X2,Y2], BarrieresH, BarrieresV, [Xadv,Yadv]) :-
  validePositionPion([X2,Y2],[Xadv,Yadv]) ,   %la position voulue est sur le plateau et pas sur l'adversaire
  deplacementVertical([X1,Y1], [X2,Y2]),    %on parle bien d'un déplacement vertical
  accessiblePionBarrieresH([X1,Y1], [X2,Y2], BarrieresH, 0).    %la position est bien accessible

%-------------------------------------------------------------------------------
%%POUR UN DEPLACEMENT HORIZONTAL

%true si le déplacement voulu est horizontal et à proximité
%deplacementHorizontal([X1,Y1],[X2,Y2])
deplacementHorizontal([X1,Y1],[X1,Y2]) :- Y1 is Y2+1.   %vers la droite
deplacementHorizontal([X1,Y1],[X1,Y2]) :- Y1 is Y2-1.   %vers la gauche

%tests d'alignements horizontal
%alignementHorizontalBarriereVerticale(BY,Y1,Y2)
alignementHorizontalBarriereVerticale(BY,BY,Y2) :- Y2>BY.   %barrière à droite pour un déplacement vers la droite
alignementHorizontalBarriereVerticale(BY,Y1,BY) :- Y1>BY.   %barrière à gauche pour un déplacement vers la gauche

%tests d'alignements vertical
%alignementVerticalBarriereVerticale(BX,X)
alignementVerticalBarriereVerticale(BX,BX).   %le "début" de la barrière nous bloque
alignementVerticalBarriereVerticale(BX,X) :- BX is X-1.   %la "fin" de la barrière nous bloque

%false s'il y a une barrière verticale qui nous bloque
%accessiblePionBarrieresV(PositionActuelle, PositionVoulue, BarrieresV, nbBarrièresBloquant)
accessiblePionBarrieresV(_, _, [], 0).    %plus aucune barrière nous bloque et aucune des précédentes non plus (Acc=0) donc c'est bon
accessiblePionBarrieresV([X1,Y1], [X2,Y2], [BX|[BY|Q]], Acc) :-   %cas où il y a une barrière qui nous embête
  alignementVerticalBarriereVerticale(BX,X1) ,
  alignementHorizontalBarriereVerticale(BY,Y1,Y2) ,
  !,    %permet d'éviter le redo car on va arriver à accessiblePionBarrieresV(_, _, [], Acc) avec Acc>0 ce qui entraine une sortie false (c'est ce qu'on veut car une barrière nous empêche de passer)
  accessiblePionBarrieresV([X1,Y1], [X2,Y2], Q, Acc+1).
accessiblePionBarrieresV(PositionActuelle, PositionVoulue, [_|[_|Q]], Acc) :- accessiblePionBarrieresV(PositionActuelle, PositionVoulue, Q, Acc).   %la barrière "courante" ne pose pas de problème donc on regarde les suivantes

%true si le déplacement voulu est réalisable (et horizontal)
%accessiblePion([X1,Y1], [X2,Y2], BarrieresH, BarrieresV, [Xadv,Yadv])
accessiblePion([X1,Y1], [X2,Y2], BarrieresH, BarrieresV, [Xadv,Yadv]) :-
  validePositionPion([X2,Y2],[Xadv,Yadv]) ,   %la position voulue est sur le plateau et pas sur l'adversaire
  deplacementHorizontal([X1,Y1], [X2,Y2]),    %on parle bien d'un déplacement horizontal
  accessiblePionBarrieresV([X1,Y1], [X2,Y2], BarrieresV, 0).    %la position est bien accessible

%-------------------------------------------------------------------------------
%%POUR UN DEPLACEMENT SAUTE MOUTON

%DEPLACEMENT VERTICAL ----------------------------------------------------------

%true si le déplacement voulu est vertical et au delà du pion de l'adversaire
%deplacementMoutonVertical([X1,Y1],[X2,Y2],[Xadv,Yadv])
deplacementMoutonVertical([X1,Y1],[X2,Y1],[Xadv,Y1]) :- X2 is X1+2 , Xadv is X1+1.    %vers le bas
deplacementMoutonVertical([X1,Y1],[X2,Y1],[Xadv,Y1]) :- X2 is X1-2 , Xadv is X1-1.    %vers le haut

%true s'il n'y a pas de barrière horizontale qui nous bloque
%accessibleMoutonVertical(Position1, Position2, BarrieresH, PositionAdv)
accessibleMoutonVertical([X1,Y1], [X2,Y2], BarrieresH, [Xadv,Yadv]) :-
  accessiblePionBarrieresH([X1,Y1], [Xadv,Yadv], BarrieresH, 0) ,   %vérification s'il y a pas de barrière entre le départ et l'adversaire
  accessiblePionBarrieresH([Xadv,Yadv], [X2,Y2], BarrieresH, 0).   %vérification s'il y a pas de barrière entre l'adversaire et l'arrivée

%true si le déplacement voulu est réalisable
%accessiblePion([X1,Y1], [X2,Y2], BarrieresH, BarrieresV, [Xadv,Yadv])
accessiblePion([X1,Y1], [X2,Y2], BarrieresH, _, [Xadv,Yadv]) :-
  validePositionPion([X2,Y2],[Xadv,Yadv]) ,   %la position voulue est sur le plateau et pas sur l'adversaire
  deplacementMoutonVertical([X1,Y1], [X2,Y2], [Xadv,Yadv]),    %on parle bien d'un déplacement "saute-mouton" vertical
  accessibleMoutonVertical([X1,Y1], [X2,Y2], BarrieresH, [Xadv,Yadv]).    %la position est bien accessible

%DEPLACEMENT HORIZONTAL --------------------------------------------------------

%true si le déplacement voulu est horizontal et au delà du pion de l'adversaire
%deplacementMoutonHorizontal([X1,Y1],[X2,Y2],[Xadv,Yadv])
deplacementMoutonHorizontal([X1,Y1],[X1,Y2],[X1,Yadv]) :- Y2 is Y1+2 , Yadv is Y1+1.    %vers la droite
deplacementMoutonHorizontal([X1,Y1],[X1,Y2],[X1,Yadv]) :- Y2 is Y1-2 , Yadv is Y1-1.    %vers la gauche

%true s'il n'y a pas de barrière verticale qui nous bloque
%accessibleMoutonHorizontal(Position1, Position2, BarrieresV, PositionAdv)
accessibleMoutonHorizontal([X1,Y1], [X2,Y2], BarrieresV, [Xadv,Yadv]) :-
  accessiblePionBarrieresV([X1,Y1], [Xadv,Yadv], BarrieresV, 0) ,   %vérification s'il y a pas de barrière entre le départ et l'adversaire
  accessiblePionBarrieresV([Xadv,Yadv], [X2,Y2], BarrieresV, 0).   %vérification s'il y a pas de barrière entre l'adversaire et l'arrivée

%true si le déplacement voulu est réalisable
%accessiblePion([X1,Y1], [X2,Y2], BarrieresH, BarrieresV, [Xadv,Yadv])
accessiblePion([X1,Y1], [X2,Y2], _, BarrieresV, [Xadv,Yadv]) :-
  validePositionPion([X2,Y2],[Xadv,Yadv]) ,   %la position voulue est sur le plateau et pas sur l'adversaire
  deplacementMoutonHorizontal([X1,Y1], [X2,Y2], [Xadv,Yadv]),    %on parle bien d'un déplacement "saute-mouton" horizontal
  accessibleMoutonHorizontal([X1,Y1], [X2,Y2], BarrieresV, [Xadv,Yadv]).    %la position est bien accessible


%-------------------------------------------------------------------------------
%%ACCESSIBILITE POUR PLACEMENT D'UNE BARRIERE

%true si la position voulue pour la barrière est sur le plateau
%validePositionBarriere([X,Y])
validePositionBarriere([X,Y]) :- X>0 , X<9 , Y>0 , Y<9.

%-------------------------------------------------------------------------------
%%PLACEMENT BARRIERE HORIZONTALE

%true si une barrière horizontale bloque le placement d'une autre barrière horizontale
%alignementBHbloqueBH([BX,BY],[X,Y])
alignementBHbloqueBH([BX,BY],[BX,BY]).    %il y a déjà une barrière exactement à cet endroit
alignementBHbloqueBH([BX,BY],[BX,Y]) :- BY is Y-1.    %la "fin" d'une barrière existante bloque le placement de la nouvelle
alignementBHbloqueBH([BX,BY],[BX,Y]) :- BY is Y+1.    %le "début" d'une barrière existante bloque le placement de la nouvelle

%true si une barrière verticale bloque le placement d'une barrière horizontale
%alignementBVbloqueBH([BX,BY],[X,Y])
alignementBVbloqueBH([BX,BY],[BX,BY]).    %il y a une barrière verticale en travers de la position voulue pour la nouvelle barrière

%false si une barrière horizontale bloque le placement d'une autre barrière horizontale
%barriereHbloquantBarriereH(PositionVoulue, BarrieresH, Acc) :-
barriereHbloquantBarriereH(_, [], 0).    %plus aucune barrière nous bloque et aucune des précédentes non plus (Acc=0) donc c'est bon
barriereHbloquantBarriereH([X,Y], [BX|[BY|Q]], Acc) :-   %cas où il y a une barrière qui nous embête
  alignementBHbloqueBH([BX,BY],[X,Y]) ,
  !,    %permet d'éviter le redo car on va arriver à barriereHbloquantBarriereH(_, [], Acc) avec Acc>0 ce qui entraine une sortie false (c'est ce qu'on veut car une barrière nous empêche de passer)
  barriereHbloquantBarriereH([X,Y], Q, Acc+1).
barriereHbloquantBarriereH(PositionVoulue, [_|[_|Q]], Acc) :- barriereHbloquantBarriereH(PositionVoulue, Q, Acc).   %la barrière "courante" ne pose pas de problème donc on regarde les suivantes

%false si une barrière verticale bloque une barrière horizontale
%barriereVbloquantBarriereH(PositionVoulue, BarrieresV, Acc) :-
barriereVbloquantBarriereH(_, [], 0).    %plus aucune barrière nous bloque et aucune des précédentes non plus (Acc=0) donc c'est bon
barriereVbloquantBarriereH([X,Y], [BX|[BY|Q]], Acc) :-   %cas où il y a une barrière qui nous embête
  alignementBVbloqueBH([BX,BY],[X,Y]) ,
  !,    %permet d'éviter le redo car on va arriver à barriereVbloquantBarriereH(_, [], Acc) avec Acc>0 ce qui entraine une sortie false (c'est ce qu'on veut car une barrière nous empêche de passer)
  barriereVbloquantBarriereH([X,Y], Q, Acc+1).
barriereVbloquantBarriereH(PositionVoulue, [_|[_|Q]], Acc) :- barriereVbloquantBarriereH(PositionVoulue, Q, Acc).   %la barrière "courante" ne pose pas de problème donc on regarde les suivantes

%true si on peut placer la barrière horizontale
%accessibleBarrieresH(PositionVoulue, BarrieresH, BarrieresV)
accessibleBarrieresH([X,Y], BarrieresH, BarrieresV) :-
  validePositionBarriere([X,Y]) ,   %la position voulue est sur le plateau
  barriereHbloquantBarriereH([X,Y], BarrieresH, 0) ,    %aucune barrière horizontale bloque le placement
  barriereVbloquantBarriereH([X,Y], BarrieresV, 0).    %aucune barrière verticale bloque le placement

%-------------------------------------------------------------------------------
%%PLACEMENT BARRIERE VERTICALE

%true si une barrière verticale bloque le placement d'une autre barrière verticale
%alignementBVbloqueBV([BX,BY],[X,Y])
alignementBVbloqueBV([BX,BY],[BX,BY]).    %il y a une barrière exactement à l'endroit voulu
alignementBVbloqueBV([BX,BY],[X,BY]) :- BX is X-1.    %la "fin" d'une barrière nous embête
alignementBVbloqueBV([BX,BY],[X,BY]) :- BX is X+1.    %le "début" d'une barrière nous embête

%true si une barrière horizontale bloque le placement d'une barrière verticale
%alignementBHbloqueBH([BX,BY],[X,Y])
alignementBHbloqueBV([BX,BY],[BX,BY]).    %il y a une barrière horizontale en travers le l'endroit où on veut placer la barrière verticale

%false si une barrière verticale bloque le placement d'une autre barrière verticale
%barriereVbloquantBarriereV(PositionVoulue, BarrieresV, Acc) :-
barriereVbloquantBarriereV(_, [], 0).    %plus aucune barrière nous bloque et aucune des précédentes non plus (Acc=0) donc c'est bon
barriereVbloquantBarriereV([X,Y], [BX|[BY|Q]], Acc) :-   %cas où il y a une barrière qui nous embête
  alignementBVbloqueBV([BX,BY],[X,Y]) ,
  !,    %permet d'éviter le redo car on va arriver à barriereVbloquantBarriereV(_, [], Acc) avec Acc>0 ce qui entraine une sortie false (c'est ce qu'on veut car une barrière nous empêche de passer)
  barriereVbloquantBarriereV([X,Y], Q, Acc+1).
barriereVbloquantBarriereV(PositionVoulue, [_|[_|Q]], Acc) :- barriereVbloquantBarriereV(PositionVoulue, Q, Acc).   %la barrière "courante" ne pose pas de problème donc on regarde les suivantes

%vérifie si une barrière horizontale bloque une barrière verticale
%barriereHbloquantBarriereV(PositionVoulue, BarrieresH, Acc) :-
barriereHbloquantBarriereV(_, [], 0).    %plus aucune barrière nous bloque et aucune des précédentes non plus (Acc=0) donc c'est bon
barriereHbloquantBarriereV([X,Y], [BX|[BY|Q]], Acc) :-   %cas où il y a une barrière qui nous embête
  alignementBHbloqueBV([BX,BY],[X,Y]) ,  % vérification si la barrière bloque la nouvelle
  !,    %permet d'éviter le redo car on va arriver à barriereHbloquantBarriereV(_, [], Acc) avec Acc>0 ce qui entraine une sortie false (c'est ce qu'on veut car une barrière nous empêche de passer)
  barriereHbloquantBarriereV([X,Y], Q, Acc+1).
barriereHbloquantBarriereV(PositionVoulue, [_|[_|Q]], Acc) :- barriereHbloquantBarriereV(PositionVoulue, Q, Acc).   %la barrière "courante" ne pose pas de problème donc on regarde les suivantes

%true si on peut placer la barrière verticale
%accessibleBarrieresV(PositionVoulue, BarrieresH, BarrieresV)
accessibleBarrieresV([X,Y], BarrieresH, BarrieresV) :-
  validePositionBarriere([X,Y]) ,   %la position voulue est sur le plateau
  barriereHbloquantBarriereV([X,Y], BarrieresH, 0) ,    %aucune barrière horizontale bloque le placement
  barriereVbloquantBarriereV([X,Y], BarrieresV, 0).    %aucune barrière verticale bloque le placement

%%------------------------------FIN DU JEU--------------------------------------

%true si un des joueurs a gagné
%jeuTermine(PositionJ1, PositionJ2) :-
jeuTermine([9,_], _).   %le joueur 1 est arrivé en bas
jeuTermine(_, [1,_]).   %le joueur 2 est arrivé en haut

% Fin de fichier
