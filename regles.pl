%%on nous donne les paramètres avec les positions de tout et ce que le joueur veut faire

%%-----------------------POSSIBILITE DE PLACER UN PION OU UNE BARRIERE------------------
%dit si on peut placer un pion ou une barrière à l'endroit demandé
tour(Position1, Position2, BarrieresH, BarrieresV, "P1", NewPosition) :- accessiblePion(Position1, NewPosition, BarrieresH, BarrieresV, Position2).
tour(Position1, Position2, BarrieresH, BarrieresV, "P2", NewPosition) :- accessiblePion(Position2, NewPosition, BarrieresH, BarrieresV, Position1).
tour(Position1, Position2, BarrieresH, BarrieresV, "BV", NewPosition) :- accessibleBarrieresV(NewPosition, BarrieresH, BarrieresV).
tour(Position1, Position2, BarrieresH, BarrieresV, "BH", NewPosition) :- accessibleBarrieresH(NewPosition, BarrieresH, BarrieresV).


%%ACCESSIBILITE POUR LE DEPLACEMENT D'UN PION
%on veut déplacer le pion

%pion sur le plateau ?
validePositionPion(X,Y,Xadv,Yadv) :- X>0 , X<10 , Y>0 , Y<10 , \+memePosition(X,Y,Xadv,Yadv).
memePosition(X1,Y1,X1,Y1).

%%POUR UN DEPLACEMENT VERTICAL
%deplacementVertical([X1,Y1],[X2,Y2]) true si le déplacement voulu est verticale et à proximité
deplacementVertical([X1,Y1],[X2,Y1]) :- X1 is X2+1.
deplacementVertical([X1,Y1],[X2,Y1]) :- X1 is X2-1.

%true si le déplacement voulu est réalisable (et verticale)
accessiblePion([X1,Y1], [X2,Y2], BarrieresH, BarrieresV, [Xadv,Yadv]) :-
  validePositionPion(X2,Y2,Xadv,Yadv) ,
  deplacementVertical([X1,Y1], [X2,Y2]),
  accessiblePionBarrieresH([X1,Y1], [X2,Y2], BarrieresH, 0).

  %vérifie s'il y a pas une barrière horizontale qui nous bloque
  %accessiblePionBarrieresH(PositionActuelle, PositionVoulue, BarrieresH)
  accessiblePionBarrieresH(_, _, [], 0).
  accessiblePionBarrieresH([X1,Y1], [X2,Y2], [BX|[BY|Q]], Acc) :-
    alignementVerticalBarriereHorizontale(BY,Y1) ,
    alignementHorizontalBarriereHorizontale(BX,X1,X2) ,
    !,
    accessiblePionBarrieresH([X1,Y1], [X2,Y2], Q, Acc+1).
  accessiblePionBarrieresH(PositionActuelle, PositionVoulue, [_|[_|Q]], Acc) :- accessiblePionBarrieresH(PositionActuelle, PositionVoulue, Q, Acc).

  %tests d'alignements
  alignementVerticalBarriereHorizontale(BY,BY).  %le 2ème BY c'est le Y1
  alignementVerticalBarriereHorizontale(BY,Y) :- BY is Y-1.

  alignementHorizontalBarriereHorizontale(BX,BX,X2) :- X2>BX.  %le 2ème BX c'est le X1
  alignementHorizontalBarriereHorizontale(BX,X1,BX) :- X1>BX.  %le 2ème BX c'est le X2

%----------------------------------------------------------------------------------------------------
%%POUR UN DEPLACEMENT HORIZONTAL
%deplacementHorizontal([X1,Y1],[X2,Y2]) true si le déplacement voulu est horizontale et à proximité
deplacementHorizontal([X1,Y1],[X1,Y2]) :- Y1 is Y2+1.
deplacementHorizontal([X1,Y1],[X1,Y2]) :- Y1 is Y2-1.

%true si le déplacement voulu est réalisable (et horizontale)
accessiblePion([X1,Y1], [X2,Y2], BarrieresH, BarrieresV, [Xadv,Yadv]) :-
  validePositionPion(X2,Y2,Xadv,Yadv) ,
  deplacementHorizontal([X1,Y1], [X2,Y2]),
  accessiblePionBarrieresV([X1,Y1], [X2,Y2], BarrieresV, 0).

%vérifie s'il y a pas une barrière horizontale qui nous bloque
%accessiblePionBarrieresH(PositionActuelle, PositionVoulue, BarrieresH)
accessiblePionBarrieresV(_, _, [], 0).
accessiblePionBarrieresV([X1,Y1], [X2,Y2], [BX|[BY|Q]], Acc) :-
  alignementHorizontalBarriereVerticale(BX,X1) ,
  alignementVerticalBarriereVerticale(BY,Y1,Y2) ,
  !,
  accessiblePionBarrieresV([X1,Y1], [X2,Y2], Q, Acc+1).
accessiblePionBarrieresV(PositionActuelle, PositionVoulue, [_|[_|Q]], Acc) :- accessiblePionBarrieresV(PositionActuelle, PositionVoulue, Q, Acc).

%tests d'alignements
alignementVerticalBarriereVerticale(BY,BY,Y2) :- Y2>BY.  %le 2ème BX c'est le X1
alignementVerticalBarriereVerticale(BY,Y1,BY) :- Y1>BY.  %le 2ème BX c'est le X2

alignementHorizontalBarriereVerticale(BX,BX).  %le 2ème BY c'est le Y1
alignementHorizontalBarriereVerticale(BX,X) :- BX is X-1.


%----------------------------------------------------------------------------------------------------
%%POUR UN DEPLACEMENT SAUTE MOUTON

%DEPLACEMENT VERTICAL ------------------
%deplacementMoutonVertical([X1,Y1],[X2,Y2],[Xadv,Yadv])
deplacementMoutonVertical([X1,Y1],[X2,Y1],[Xadv,Y1]) :- X2 is X1+2 , Xadv is X1+1.
deplacementMoutonVertical([X1,Y1],[X2,Y1],[Xadv,Y1]) :- X2 is X1-2 , Xadv is X1-1.

%accessibleMoutonVertical(Position1, Position2, BarrieresH, PositionAdv)
accessibleMoutonVertical([X1,Y1], [X2,Y2], BarrieresH, [Xadv,Yadv]) :-
  accessiblePionBarrieresH([X1,Y1], [Xadv,Yadv], BarrieresH, 0) ,
  accessiblePionBarrieresH([Xadv,Yadv], [X2,Y2], BarrieresH, 0).

%true si le déplacement voulu est réalisable
accessiblePion([X1,Y1], [X2,Y2], BarrieresH, _, [Xadv,Yadv]) :-
  validePositionPion(X2,Y2,Xadv,Yadv) ,
  deplacementMoutonVertical([X1,Y1], [X2,Y2], [Xadv,Yadv]),
  accessibleMoutonVertical([X1,Y1], [X2,Y2], BarrieresH, [Xadv,Yadv]).

%DEPLACEMENT HORIZONTAL ------------------
%deplacementMoutonHorizontal([X1,Y1],[X2,Y2],[Xadv,Yadv])
deplacementMoutonHorizontal([X1,Y1],[X1,Y2],[X1,Yadv]) :- Y2 is Y1+2 , Yadv is Y1+1.
deplacementMoutonHorizontal([X1,Y1],[X1,Y2],[X1,Yadv]) :- Y2 is Y1-2 , Yadv is Y1-1.

%accessibleMoutonHorizontal(Position1, Position2, BarrieresV, PositionAdv)
accessibleMoutonHorizontal([X1,Y1], [X2,Y2], BarrieresV, [Xadv,Yadv]) :-
  accessiblePionBarrieresV([X1,Y1], [Xadv,Yadv], BarrieresV, 0) ,
  accessiblePionBarrieresV([Xadv,Yadv], [X2,Y2], BarrieresV, 0).

%true si le déplacement voulu est réalisable
accessiblePion([X1,Y1], [X2,Y2], _, BarrieresV, [Xadv,Yadv]) :-
  validePositionPion(X2,Y2,Xadv,Yadv) ,
  deplacementMoutonHorizontal([X1,Y1], [X2,Y2], [Xadv,Yadv]),
  accessibleMoutonHorizontal([X1,Y1], [X2,Y2], BarrieresV, [Xadv,Yadv]).


%--------------------------------------------------------------------------------------------------
%%ACCESSIBILITE POUR PLACEMENT D'UNE BARRIERE

%barrière posable ?
validePositionBarriere(X,Y) :- X>0 , X<9 , Y>0 , Y<9.

%%PLACEMENT BARRIERE HORIZONTALE
%vérifie si on peut placer la barrière horizontale
%accessibleBarrieresH(PositionVoulue, BarrieresH, BarrieresV)
accessibleBarrieresH([X,Y], BarrieresH, BarrieresV) :-
  validePositionBarriere(X,Y) ,
  barriereHbloquantBarriereH([X,Y], BarrieresH, 0) ,
  barriereVbloquantBarriereH([X,Y], BarrieresV, 0).

%vérifie si une barrière horizontale bloque le placement d'une autre barrière horizontale
%barriereHbloquantBarriereH(PositionVoulue, BarrieresH, Acc) :-
barriereHbloquantBarriereH(_, [], 0). %condition d'arrêt où il y a plus de barrières
barriereHbloquantBarriereH([X,Y], [BX|[BY|Q]], Acc) :-
  alignementBHbloqueBH(BX,BY,X,Y) ,  % vérification si la barrière bloque la nouvelle
  !,
  barriereHbloquantBarriereH([X,Y], Q, Acc+1).
barriereHbloquantBarriereH(PositionVoulue, [_|[_|Q]], Acc) :- barriereHbloquantBarriereH(PositionVoulue, Q, Acc).

%vérifie si une barrière verticale bloque une barrière horizontale
%barriereVbloquantBarriereH(PositionVoulue, BarrieresV, Acc) :-
barriereVbloquantBarriereH(_, [], 0).
barriereVbloquantBarriereH([X,Y], [BX|[BY|Q]], Acc) :-
  alignementBVbloqueBH(BX,BY,X,Y) ,  % vérification si la barrière bloque la nouvelle
  !,
  barriereVbloquantBarriereH([X,Y], Q, Acc+1).
barriereVbloquantBarriereH(PositionVoulue, [_|[_|Q]], Acc) :- barriereVbloquantBarriereH(PositionVoulue, Q, Acc).

%vérification des alignements
%alignementBHbloqueBH(BX,BY,X,Y)
alignementBHbloqueBH(BX,BY,BX,BY).
alignementBHbloqueBH(BX,BY,BX,Y) :- BY is Y-1.
alignementBHbloqueBH(BX,BY,BX,Y) :- BY is Y+1.

%alignementBVbloqueBH(BX,BY,X,Y)
alignementBVbloqueBH(BX,BY,BX,BY).

%--------------------------------------------------------------------------------------------------
%%PLACEMENT BARRIERE VERTICALE
%vérifie si on peut placer la barrière verticale
accessibleBarrieresV([X,Y], BarrieresH, BarrieresV) :-
  validePositionBarriere(X,Y) ,
  barriereHbloquantBarriereV([X,Y], BarrieresH, 0) ,
  barriereVbloquantBarriereV([X,Y], BarrieresV, 0).

%barriereVbloquantBarriereV(PositionVoulue, BarrieresV, Acc) :-
barriereVbloquantBarriereV(_, [], 0). %condition d'arrêt où il y a plus de barrières
barriereVbloquantBarriereV([X,Y], [BX|[BY|Q]], Acc) :-
  alignementBVbloqueBV(BX,BY,X,Y) ,  % vérification si la barrière bloque la nouvelle
  !,
  barriereVbloquantBarriereV([X,Y], Q, Acc+1).
barriereVbloquantBarriereV(PositionVoulue, [_|[_|Q]], Acc) :- barriereVbloquantBarriereV(PositionVoulue, Q, Acc).

%vérifie si une barrière verticale bloque une barrière horizontale
%barriereHbloquantBarriereV(PositionVoulue, BarrieresV, Acc) :-
barriereHbloquantBarriereV(_, [], 0).
barriereHbloquantBarriereV([X,Y], [BX|[BY|Q]], Acc) :-
  alignementBHbloqueBV(BX,BY,X,Y) ,  % vérification si la barrière bloque la nouvelle
  !,
  barriereHbloquantBarriereV([X,Y], Q, Acc+1).
barriereHbloquantBarriereV(PositionVoulue, [_|[_|Q]], Acc) :- barriereHbloquantBarriereV(PositionVoulue, Q, Acc).

%vérification des alignements
%alignementBHbloqueBH(BX,BY,X,Y)
alignementBVbloqueBV(BX,BY,BX,BY).
alignementBVbloqueBV(BX,BY,X,BY) :- BX is X-1.
alignementBVbloqueBV(BX,BY,X,BY) :- BX is X+1.

%alignementBVbloqueBH(BX,BY,X,Y)
alignementBHbloqueBV(BX,BY,BX,BY).

%%------------------------------FIN DU JEU-----------------
%jeuTermine(Position1, Position2) :-
jeuTermine([1,_], _).
jeuTermine(_, [9,_]).
