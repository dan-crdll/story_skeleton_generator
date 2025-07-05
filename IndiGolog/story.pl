/*  

  Story Generator domain for INDIGOLOG
  Daniele S. Cardullo - P&R 24-25 Project

*/

:- dynamic controller/1.
:- discontiguous
    fun_fluent/1,
    rel_fluent/1,
    proc/2,
    causes_true/3,
    causes_false/3.


% There is nothing to do caching on (required because cache/1 is static)
cache(_) :- fail.

/* PREDICATES */

/* define characters */
character(hero).
character(princess).
character(ally1).
character(enemy1).
character(orc).
character(goblin).

/* define locations */
location(home).
location(armory).
location(cave).
location(castle).
location(mountain).
location(village).
location(forest).
location(secret_cave).

/* define objects */
object(treasure).
object(sword).
object(bow).
object(dagger).
object(magic_gem).
object(golden_ring).

/* object types */
weapon(sword).
weapon(bow).
weapon(dagger).

treasure_item(treasure).
treasure_item(magic_gem).

/* define enemies */
enemy(enemy1).
enemy(orc).
enemy(goblin).

/* FLUENTS and CAUSAL LAWS */

/* at: if an object/character is at a certain location */
rel_fluent(at(X, L)) :- character(X), location(L).
rel_fluent(at(X, L)) :- object(X), location(L).

% causal laws for move action
causes_true(move(Char, From, To), at(Char, To), true).
causes_false(move(Char, From, To), at(Char, From), at(Char, From)).

% causal laws for pick action
causes_false(pick(Char, Object), at(Object, Location), at(Object, Location)).
causes_true(pick(Char, Object), has(Char, Object), true).

% causal laws for fight action
causes_false(fight(Char, Enemy), alive(Enemy), alive(Enemy)).
causes_false(fight(Char, Enemy), at(Enemy, Location), at(Enemy, Location)).
causes_true(fight(Char, Enemy), has(Char, Object), 
  (has(Enemy, Object), alive(Enemy))).

% causal laws for give action
causes_false(give(Giver, Receiver, Object), has(Giver, Object), has(Giver, Object)).
causes_true(give(Giver, Receiver, Object), has(Receiver, Object), true).

% causal laws for exogenous actions
causes_true(enemy_spawns(Enemy, Location), at(Enemy, Location), true).
causes_true(enemy_spawns(Enemy, Location), alive(Enemy), true).
causes_true(treasure_appears(Treasure, Location), at(Treasure, Location), true).

/* has: if a character has a certain object */
rel_fluent(has(C, O)) :- character(C), object(O).

% causal laws already defined above for pick, fight, give actions

/* know: if a character knows the location of an object */
rel_fluent(know(C, O, L)) :- character(C), object(O), location(L).

% causal laws for talk actions
causes_true(talkTo(C1, C2), know(C1, Object, Location), know(C2, Object, Location)).
causes_true(talkToInExchange(C1, C2, ExchObj), know(C1, Object, Location), 
  (knowInExchange(C2, Object, ExchObj), has(C1, ExchObj))).

/* reachable: if a character knows how to reach a location */
rel_fluent(reachable(C, L)) :- character(C), location(L).

% causal laws already defined above for read and talk actions

/* knowInExchange: if a character will share knowledge in exchange for something */
rel_fluent(knowInExchange(C, O, E)) :- character(C), object(O), object(E).

/* alive: if a character is alive */
rel_fluent(alive(C)) :- character(C).

% causal laws already defined above for fight action

/* atHome: if the main character is at home */
rel_fluent(atHome(C, L)) :- character(C), location(L).

/* enemyPresent: if there are enemies at a location */
rel_fluent(enemyPresent(L)) :- location(L).

causes_true(enemy_spawns(Enemy, Location), enemyPresent(Location), true).
causes_false(fight(Char, Enemy), enemyPresent(Location), 
  at(Enemy, Location)).

/* ACTIONS and PRECONDITIONS */

prim_action(move(Char, From, To)) :- character(Char), location(From), location(To).
poss(move(Char, From, To), (
  at(Char, From),
  reachable(Char, To),
  \+ (=(From, To)),
  \+ enemyPresent(From)
)).

prim_action(pick(Char, Object)) :- character(Char), object(Object).
poss(pick(Char, Object), (
  at(Char, Location),
  at(Object, Location),
  \+ has(_, Object),
  \+ enemyPresent(Location)
)).

prim_action(fight(Char, Enemy)) :- character(Char), enemy(Enemy).
poss(fight(Char, Enemy), (
  at(Char, Location),
  at(Enemy, Location),
  alive(Enemy),
  has(Char, Weapon),
  weapon(Weapon)
)).

prim_action(talkTo(C1, C2)) :- character(C1), character(C2).
poss(talkTo(C1, C2), (
  at(C1, Location),
  at(C2, Location),
  \+ (=(C1, C2)),
  \+ enemyPresent(Location)
)).

prim_action(talkToInExchange(C1, C2, Object)) :- character(C1), character(C2), object(Object).
poss(talkToInExchange(C1, C2, Object), (
  at(C1, Location),
  at(C2, Location),
  has(C1, Object),
  knowInExchange(C2, _, Object),
  \+ enemyPresent(Location)
)).

prim_action(give(Giver, Receiver, Object)) :- character(Giver), character(Receiver), object(Object).
poss(give(Giver, Receiver, Object), (
  at(Giver, Location),
  at(Receiver, Location),
  has(Giver, Object)
)).

/* EXOGENOUS ACTIONS */

/* enemy spawns at a location */
exog_action(enemy_spawns(Enemy, Location)) :- enemy(Enemy), location(Location).

/* treasure appears at a location */
exog_action(treasure_appears(Treasure, Location)) :- treasure_item(Treasure), location(Location).

prim_action(Act) :- exog_action(Act).

poss(enemy_spawns(Enemy, Location), (
  \+ at(Enemy, Location),
  \+ alive(Enemy)
)) :- enemy(Enemy), location(Location).

poss(treasure_appears(Treasure, Location), (
  \+ at(Treasure, Location)
)) :- treasure_item(Treasure), location(Location).


/* INITIAL STATE */

initially(at(hero, home), true).
initially(at(treasure, cave), true).
initially(at(sword, armory), true).
initially(at(enemy1, cave), true).
initially(atHome(hero, home), true).
initially(know(hero, treasure, cave), true).
initially(know(hero, sword, armory), true).
initially(alive(hero), true).
initially(alive(enemy1), true).
initially(enemyPresent(cave), true).

initially(at(princess, castle), true).
initially(at(magic_gem, mountain), true).
initially(know(princess, magic_gem, mountain), true).
initially(knowInExchange(princess, magic_gem, golden_ring), true).
initially(alive(princess), true).

initially(at(X, L), false) :- character(X), location(L), \+ initially(at(X, L), true).
initially(at(X, L), false) :- object(X), location(L), \+ initially(at(X, L), true).
initially(has(C, O), false) :- character(C), object(O), \+ initially(has(C, O), true).
initially(know(C, O, L), false) :- character(C), object(O), location(L), \+ initially(know(C, O, L), true).
initially(reachable(C, L), true) :- character(C), location(L), true.
initially(knowInExchange(C, O, E), false) :- character(C), object(O), object(E), \+ initially(knowInExchange(C, O, E), true).
initially(alive(C), false) :- character(C), \+ initially(alive(C), true).
initially(atHome(C, L), false) :- character(C), location(L), \+ initially(atHome(C, L), true).
initially(enemyPresent(L), false) :- location(L), \+ initially(enemyPresent(L), true).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Definitions of complex actions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

proc(goto_loc(D), [
if(at(hero, D), [], [pi([from], [?(at(hero, from)), move(hero, from, D)])])
]).

/* CONTROLLERS */
proc(control(patroling_controller), patroling).
proc(patroling, [
  if((\+ has(hero, sword)), 
    [goto_loc(armory), pick(hero,sword)], 
    []),

  while((true), [
    if(some([en], (enemy(en), alive(en))),
      [search(pi([en, loc], [?(enemy(en)), ?(alive(en)), ?(at(en, loc)), goto_loc(loc), fight(hero, en)
      ]))],
      [
        if(at(hero, home), [], [goto_loc(home)])
      ]
    )
  ])
]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  INFORMATION FOR THE EXECUTOR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Translations of domain actions to real actions (one-to-one)
actionNum(X, X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EOF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%