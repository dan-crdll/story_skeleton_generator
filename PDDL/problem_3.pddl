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
    (know friend mysterious_man tavern)
    (has mysterious_man map_1)
    (know mysterious_man monk monastery)
    (knowInExchange monk old_book treasure evil_wizard_house)
    (has monk dagger)
    (know monk knight castle)
    (know knight crown thief_house)
    (knowInExchange knight dagger old_book ruins)
    (know knight princess castle)
    (knowInExchange princess crown sword castle)

    (at enemy_1 ruins)
    (at enemy_2 ruins)
    (at enemy_3 ruins)

    (at thief thief_house)

    (at evil_wizard evil_wizard_house)
)

(:goal (and
    (at main_c village)
    (has main_c treasure)
))

;un-comment the following line if metric is needed
; (:metric minimize (movements main_c))
)