(define (problem boring_story) (:domain story)
(:objects 
    main_c - main_character
    map_1 - map
    treasure - pickable
    village castle cave - location
    sword - weapon
    E1 E2 E3 E4 - enemy
)

(:init
    (atHome village)
    (at main_c village)
    (has main_c map_1)
    (at treasure cave)
    (at E1 cave)
    (at E2 cave)
    (at E3 cave)
    (at E4 cave)
    (at sword castle)
    (know main_c sword castle)
    (know main_c treasure cave)
)

(:goal (and
    (has main_c treasure)
    (at main_c village)
))

(:metric minimize (movements main_c))
)
