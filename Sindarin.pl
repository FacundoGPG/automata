% PATHS

path(q0, 'N', q1). % From q0, reading 'N' moves to q1

% From q1 it branches based on the next letter
path(q1, i, q2).   % "Ni..."
path(q1, u, q9).   % "Nu..."
path(q1, o, q19).  % "No..."
path(q1, e, q24).  % "Ne..."
path(q1, a, q13).  % "Na..."

% Nin / Nimrais
path(q2, n, q3).   % completes "Nin"
path(q2, m, q4).   % continues "Nimrais"

path(q4, r, q5).
path(q5, a, q6).
path(q6, i, q7).
path(q7, s, q8).   % completes "Nimrais"

% Numen
path(q9, m, q10).
path(q10, e, q11).
path(q11, n, q12). % completes "Numen"

% Naug / Naugrim
path(q13, u, q14).
path(q14, g, q15). % completes "Naug"

path(q15, r, q16). % continues "Naugrim"
path(q16, i, q17).
path(q17, m, q18). % completes "Naugrim"

% Nogoth
path(q19, g, q20).
path(q20, o, q21).
path(q21, t, q22).
path(q22, h, q23). % completes "Nogoth"

% Negyth
path(q24, g, q25).
path(q25, y, q26).
path(q26, t, q27).
path(q27, h, q28). % completes "Negyth"


% ACCEPTING STATES

accepting_state(q3).   % Nin
accepting_state(q8).   % Nimrais
accepting_state(q12).  % Numen
accepting_state(q15).  % Naug
accepting_state(q18).  % Naugrim
accepting_state(q23).  % Nogoth
accepting_state(q28).  % Negyth


% AUTOMATON FORMULA

run_automaton([], CurrentState) :-
    accepting_state(CurrentState).
% Reads the list, if no symbols are left, accept only if current state is final

run_automaton([Letter | Remaining], CurrentState) :-
    path(CurrentState, Letter, NextState),
    run_automaton(Remaining, NextState).
% Takes first letter, moves to next state, and continues with the rest


% ENTRY POINT / WORD INPUT

check_word(Word) :-
    run_automaton(Word, q0).
% Starts the automaton from the initial state q0

