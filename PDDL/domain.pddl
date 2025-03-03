(define (domain story)

(:requirements :strips :adl :typing :negative-preconditions)

(:types
    character pickable - positionable
    main_character npc enemy - character 
    util weapon - pickable
    map - util  
    location
)

(:predicates
    (at ?x - positionable ?where - location)
    (reachable ?x1 ?x2 - location)
    (has ?x - character ?y - pickable)
    (know ?x - character ?what - positionable ?where - location)
    (knowInExchange ?x - character ?y - pickable ?what - positionable ?where - location)
    (atHome ?x - location)
)

(:functions 
    (movements ?x - main_character)
)

(:action move
    :parameters (?x - main_character ?from ?to - location)
    :precondition (and 
        (reachable ?from ?to)
        (at ?x ?from)
    )
    :effect (and 
        (at ?x ?to)
        (not (at ?x ?from))
        ; (when 
        ;     (and (atHome ?to))
        ;     (and (increase (movements ?x) 3))
        ; )
        ; (when 
        ;     (and (not (atHome ?to)))
        ;     (and (increase (movements ?x) 5))
        ; )
    )
)

(:action pick
    :parameters (?x - main_character ?what - pickable ?where - location)
    :precondition (and 
        (at ?what ?where)
        (at ?x ?where)
        (not (exists (?e - enemy) (and (at ?e ?where))))
    )
    :effect (and 
        (has ?x ?what)
        (not (at ?what ?where))
    )
)

(:action fight
    :parameters (?x - main_character ?where - location ?weapon - weapon)
    :precondition (and 
        (at ?x ?where)
        (has ?x ?weapon)
        (exists (?e - enemy) (and (at ?e ?where)))
    )
    :effect (and 
        (forall (?e - enemy) (
            when (at ?e ?where) 
            (and 
                (not (at ?e ?where))
            )
        ))
    )
)

(:action read
    :parameters (?x - main_character ?m - map ?from ?to - location)
    :precondition (and 
        (has ?x ?m)
        (at ?x ?from)
        (not (at ?x ?to))
        (or 
            (exists (?z - positionable) (know ?x ?z ?to))
            (atHome ?to)
        )
        (not (exists (?e - enemy) (at ?e ?from)))
    )
    :effect (and 
        (reachable ?from ?to) 
        ; (increase (movements ?x) 1)
    )
)

(:action talkTo
    :parameters (?x - main_character ?y - npc ?where - location ?what - positionable ?place - location)
    :precondition (and 
        (at ?x ?where)
        (at ?y ?where)
        (know ?y ?what ?place)
        (not (exists (?e - enemy) (at ?e ?where)))
    )
    :effect (and 
        (know ?x ?what ?place)
        (at ?what ?place)
    )
)

(:action talkToInExchange
    :parameters (?x - main_character ?y - npc ?z - pickable ?where - location ?what - positionable ?place - location)
    :precondition (and 
        (at ?x ?where)
        (at ?y ?where)
        (has ?y ?z)
        (knowInExchange ?y ?z ?what ?place)
        (not (exists (?e - enemy) (at ?e ?where)))
    )
    :effect (and 
        (know ?x ?what ?place)
        (at ?what ?place)
    )
)

(:action give
    :parameters (?x - character ?y - character ?where - location ?what - pickable)
    :precondition (and 
        (at ?x ?where)
        (at ?y ?where)
        (has ?x ?what)
        (not (exists (?smth - positionable ?smwh - location)
            (knowInExchange ?x ?what ?smth ?smwh)
        ))
    )
    :effect (and 
        (has ?y ?what)
        (not (has ?x ?what))
    )
)

)
