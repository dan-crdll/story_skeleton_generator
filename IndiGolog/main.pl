/*  

	Main file for Story Generator domain in INDIGOLOG
	Daniele S. Cardullo - P&R 24-25 Project

*/


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONSULT INDIGOLOG FRAMEWORK
%
%    Configuration files
%    Interpreter
%    Environment manager
%    Evaluation engine/Projector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- dir(indigolog, F), consult(F).
:- dir(eval_bat, F), consult(F).    % after interpreter always!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONSULT APPLICATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- [story].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPECIFY ADDRESS OF ENVIRONMENT MANAGER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Any port available would be ok for the EM.
em_address(localhost, 4000).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENVIRONMENTS/DEVICES TO LOAD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load_devices([simulator]).

% start story environment simulator

load_device(simulator, Host:Port, [pid(PID)]) :-
	dir(dev_simulator, File),
	ARGS = ['-e', 'swipl', '-t', 'start', File, '--host', Host, '--port', Port],
	logging(
		info(5, app), "Command to initialize device simulator: xterm -e ~w", [ARGS]),
	process_create(
		path(xterm), ARGS,
		[process(PID)]).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HOW TO EXECUTE ACTIONS: Environment + low-level Code
%        how_to_execute(Action, Environment, Code)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sensing actions (if any are defined)
how_to_execute(Action, simulator, sense(Action)) :-
	sensing_action(Action, _).

% Regular actions
how_to_execute(Action, simulator, Action) :-
	 \+ sensing_action(Action, _).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   EXOGENOUS ACTION AND SENSING OUTCOME TRANSLATION
%
%          translate_exog(Code, Action)
%          translate_sensing(Action, Outcome, Value)
%
% OBS: If not present, then the translation is 1-1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

translate_exog(ActionCode, Action) :-
	actionNum(Action, ActionCode), !.
translate_exog(A, A).
translate_sensing(_, SR, SR).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAIN PREDICATE - evaluate this to run demo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% main/0: Gets INDIGOLOG to evaluate a chosen story controller

main :-
	findall(C,
		proc(
			control(C), _), LC),
	length(LC, N), repeat,
	format('~n=== Story Generator Controllers Available ===~n'),
	format('Controllers available: ~w~n', [LC]),
	forall(
		(
			between(1, N, I),
			nth1(I, LC, C)),
		format('~d. ~w~n', [I, C])), nl,
	write('Select story controller: '),
	read(NC), nl,
	number(NC),
	nth1(NC, LC, C),
	format('~n=== Executing Story Controller: *~w* ===~n', [C]), !,
	main(
		control(C)).

main(C) :-
	assert(
		controller(C)),
	indigolog(C).


% Set logging levels for story domain
:- set_option(log_level, 5).
:- set_option(log_level, em(1)).
:- set_option(wait_step, 3).  % Shorter wait for story interactions


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STORY-SPECIFIC TASKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* Legality Task: Check if a sequence of story actions is legal */
legality_task :-
	format("~n=== Story Legality Check ===~n"),
	format("Enter sequence of story actions to check:~n"),
	format("Example: [move(hero,home,armory), pick(hero,sword)]~n"),
	read(SEQ), nl,
	format("Checking legality of: ~w~n", [SEQ]),
	indigolog(SEQ).


/* Projection Task: Check story conditions after action sequence */
projection_task :-
	format("~n=== Story Projection Task ===~n"),
	format("Enter story condition to check:~n"),
	format("Example: has(hero,treasure)~n"),
	read(COND), nl,
	format("Enter sequence of story actions:~n"),
	format("Example: [move(hero,home,cave), pick(hero,treasure)]~n"),
	read(SEQ), nl,
	format("Projecting condition ~w after actions ~w~n", [COND, SEQ]),
	indigolog([SEQ, ?(COND)]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENHANCED MAIN MENU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Enhanced main menu with story-specific options
story_menu :-
	repeat,
	format("~n===============================================~n", []),
    format("        STORY GENERATOR - INDIGOLOG           ~n", []),
    format("===============================================~n", []),
    format("1. Run Story Controller~n", []),
    format("2. Legality Check~n", []),
    format("3. Projection Task~n", []),
    format("4. Quit~n", []),
    format("===============================================~n", []),
	write('Select option (1-4): '),
	read(Choice), nl,
	(   Choice = 1 -> main
	;   Choice = 2 -> legality_task
	;   Choice = 3 -> projection_task
	;   Choice = 4 -> (format("Goodbye!~n"), !)
	;   format("Invalid choice. Please select 1-4.~n")
	),
	Choice \= 4,
	fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STARTUP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Auto-start with story menu
:- initialization(story_menu).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EOF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%