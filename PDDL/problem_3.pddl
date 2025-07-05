(define (problem predestined_tale) (:domain story)
(:objects 
    main_c - main_character
    friend mysterious_man monk knight princess - npc 
    enemy_1 enemy_2 enemy_3 evil_wizard thief - enemy 
    village tavern castle monastery ruins thief_house evil_wizard_house - location 
    map_1 - map 
    old_book crown treasure - pickable
    dagger sword - weapon
)

(:init
    (atHome village)
    (at main_c village)
    (at friend tavern)
    (know main_c friend tavern)
    (reachable village tavern)
    (has mysterious_man map_1)
    (know friend mysterious_man tavern)
    (know mysterious_man monk monastery) 
    (knowInExchange monk old_book treasure evil_wizard_house)
    (has monk dagger)
    (know monk knight castle)
    (knowInExchange knight dagger sword castle)
    (know knight old_book ruins)
    (at enemy_1 ruins)
    (at enemy_2 ruins)
    (at old_book ruins)
    (at evil_wizard evil_wizard_house)
    (at treasure evil_wizard_house)
)

(:goal (and
    (at main_c village)
    (has main_c treasure)
))

(:metric minimize (movements main_c))
)