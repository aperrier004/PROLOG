% Appel de la librairie
:- use_module(library(pce)).


create_person_dialog :-
    new(D, dialog('Enter new person')),
    send(D, append, new(label)),    % for reports
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