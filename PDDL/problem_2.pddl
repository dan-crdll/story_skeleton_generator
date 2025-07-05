(define (problem princess_tale) (:domain story)
(:objects 
    main_c - main_character
    village castle ruin cavern - location
    princess knight - npc
    enemy_1 enemy_2 - enemy
    sword - weapon
    treasure crown - pickable
    map_1 - map
)

(:init
    (atHome village)
    (has main_c map_1)
    (at main_c village)
    (at princess castle)
    (know main_c princess castle)
    (know princess knight ruin)
    (knowInExchange princess crown treasure castle)
    (know knight crown cavern) 
    (has knight sword)
    (at enemy_1 cavern)
    (at enemy_2 cavern)
)

(:goal (and
    (at main_c village)
    (has main_c treasure)
))

; (:metric minimize (movements main_c))
)
