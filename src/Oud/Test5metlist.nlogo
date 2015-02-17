breed [governments government]
breed [persons person]

turtles-own [
  countrycode
  vision
  CCawareness
  ExpectedBAUemission 
]

governments-own [
  PoliticalPreference
  DemocraticValue
]

globals [
  GHG
  cumulativeghg
  InitBAUemission
  BAUemission
  CostsTurningPointYear1
  Agreement
  Internationalpreferencelist
  cumghg
  impact
  OpinionDifference
  ChanceForSucces
  ReductionPolicy
  cumulativemitigation
  CCawarenessList
]
      
to setup
  clear-all
  reset-ticks
  
  create-persons #persons[
    set color white
    set shape "circle"
    set size .4
    ask persons [set countrycode ceiling ((who + 1) * #governments / #persons) ]    
    set xcor random-normal (min-pxcor + (max-pxcor - min-pxcor - 4) / #governments * countrycode) 1
    set ycor random-normal -5 1
    
    ask persons with [countrycode = 1] [set vision random-normal Vision1 SDVisionDistribution
    while [(vision > 100) or (vision < 0)]  [set vision random-normal Vision1 SDVisionDistribution]]
    ask persons with [countrycode = 2] [set vision random-normal Vision2 SDVisionDistribution
    while [(vision > 100) or (vision < 0)]  [set vision random-normal Vision2 SDVisionDistribution]]
    ask persons with [countrycode = 3] [set vision random-normal Vision3 SDVisionDistribution
    while [(vision > 100) or (vision < 0)]  [set vision random-normal Vision3 SDVisionDistribution]]
    ask persons with [countrycode = 4] [set vision random-normal Vision4 SDVisionDistribution
    while [(vision > 100) or (vision < 0)]  [set vision random-normal Vision4 SDVisionDistribution]]
    ask persons with [countrycode = 5] [set vision random-normal Vision5 SDVisionDistribution
    while [(vision > 100) or (vision < 0)]  [set vision random-normal Vision5 SDVisionDistribution]]
    ask persons with [countrycode = 6] [set vision random-normal Vision6 SDVisionDistribution
    while [(vision > 100) or (vision < 0)]  [set vision random-normal Vision6 SDVisionDistribution]]
    ask persons with [countrycode = 7] [set vision random-normal Vision7 SDVisionDistribution
    while [(vision > 100) or (vision < 0)]  [set vision random-normal Vision7 SDVisionDistribution]]
    ask persons with [countrycode = 8] [set vision random-normal Vision8 SDVisionDistribution
    while [(vision > 100) or (vision < 0)]  [set vision random-normal Vision8 SDVisionDistribution]]
    ask persons with [countrycode = 9] [set vision random-normal Vision9 SDVisionDistribution
    while [(vision > 100) or (vision < 0)]  [set vision random-normal Vision9 SDVisionDistribution]]
    ask persons with [countrycode = 10] [set vision random-normal Vision10 SDVisionDistribution
    while [(vision > 100) or (vision < 0)]  [set vision random-normal Vision10 SDVisionDistribution]]   
  ]
      
  create-governments #governments[
    set color white
    set shape "orbit 6"
    set size 1
    ask governments [set countrycode who - #persons + 1] 
    set xcor min-pxcor + (max-pxcor - min-pxcor - 4) / #governments * countrycode
    set ycor random-normal 8 2
    ask governments [create-links-with other governments]
    let i  1
    while [i <= #governments] [
      ask governments with [countrycode = i] [create-links-with persons with [countrycode = i]]
      set i i + 1   
      
    ask governments with [countrycode = 1] [set vision VisionCountry1 set DemocraticValue DemocraticValue1]
    ask governments with [countrycode = 2] [set vision VisionCountry2 set DemocraticValue DemocraticValue2]
    ask governments with [countrycode = 3] [set vision VisionCountry3 set DemocraticValue DemocraticValue3]
    ask governments with [countrycode = 4] [set vision VisionCountry4 set DemocraticValue DemocraticValue4]
    ask governments with [countrycode = 5] [set vision VisionCountry5 set DemocraticValue DemocraticValue5]
    ask governments with [countrycode = 6] [set vision VisionCountry6 set DemocraticValue DemocraticValue6]
    ask governments with [countrycode = 7] [set vision VisionCountry7 set DemocraticValue DemocraticValue7]
    ask governments with [countrycode = 8] [set vision VisionCountry8 set DemocraticValue DemocraticValue8]
    ask governments with [countrycode = 9] [set vision VisionCountry9 set DemocraticValue DemocraticValue9]
    ask governments with [countrycode = 10] [set vision VisionCountry10 set DemocraticValue DemocraticValue10]
    ]
  ]  
    
    determinepoliticalpreference
    determineInitBAUemission
    determineimpactgraph
    set Internationalpreferencelist (list)
    set CCawarenessList (list)
end

to determineInitBAUemission
  ask persons [set InitBAUemission (InitBAUemission + (AmountOfYears))]; Nog beginmitigatie in verwerken
  ask governments [set InitBAUemission (InitBAUemission + ((#persons / #governments / RatioLocalEmissionNationalEmission - #persons / #governments) * AmountOfYears))]
end 

to determineimpactgraph
  set cumghg 0
  while [cumghg < (InitBAUemission * ImpactFactor / 1000)] [
    set cumghg (cumghg + 1)
    set impact (0 - ((1 - 0) / (-1 + ExpFactor ^ (InitBAUemission * ImpactFactor / 1000)))) + (((1 - 0) / (-1 + ExpFactor ^ (InitBAUemission * ImpactFactor / 1000)) * ExpFactor ^ cumghg))
    update-plots] 
end
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to go
  tick
  determineBAUemission
  determineExpectedBAUemission
  determineCCawareness
  determinepoliticalpreference
  emitGHG
  negotiations
  determineCumulativeMitigation
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to determineBAUemission
  set BAUemission 0
  ask persons [set BAUemission (BAUemission + ((AmountOfYears - ticks) * (1 - CCawareness - ReductionPolicy)))]
  ask governments [set BAUemission (BAUemission + ((#persons / #governments / RatioLocalEmissionNationalEmission - #persons / #governments) * (AmountOfYears - ticks)) * (1 - PoliticalPreference - ReductionPolicy))]
  set BAUemission BAUemission + cumulativeghg
end   

to determineExpectedBAUemission
  ask persons [ifelse ((AmountOfYears - ticks) > Vision)
  [set ExpectedBAUemission (BAUemission * (Vision / (AmountOfYears - ticks)))]
  [set ExpectedBAUemission (BAUemission)]]
  
  ask governments [ifelse ((AmountOfYears - ticks) > Vision)
  [set ExpectedBAUemission (BAUemission * (Vision / (AmountOfYears - ticks)))]
  [set ExpectedBAUemission (BAUemission)]]
end

to determineCCawareness
  ask persons [
    set CCawareness mean CCawarenessList 
    set CCawarenessList lput ((0 - ((1 - 0) / (-1 + ExpFactor ^ (InitBAUemission / 1000)))) + (((1 - 0) / (-1 + ExpFactor ^ (InitBAUemission / 1000)) * ExpFactor ^ (ExpectedBAUemission / 1000)))) CCawarenessList
    
    if CCawareness > 1 [set CCawareness 1]
    ifelse CCawareness > 0.8 [set color 65] 
    [ifelse CCawareness > 0.6 [set color 68]
      [ifelse CCawareness > 0.4 [set color 25]
        [ifelse CCawareness > 0.2 [set color 28]
          [set color 15]]
      ]
    ]
  ]
  
  ask governments [
    set CCawareness (0 - ((1 - 0) / (-1 + ExpFactor ^ (InitBAUemission / 1000)))) + (((1 - 0) / (-1 + ExpFactor ^ (InitBAUemission / 1000)) * ExpFactor ^ (ExpectedBAUemission / 1000)))
    if CCawareness > 1 [set CCawareness 1]
  ]
end

to determinepoliticalpreference
  let j  1
  while [j <= #governments] [
    ask governments with [countrycode = j] [set politicalpreference (((mean [CCawareness] of persons with [countrycode = j]) * DemocraticValue) + (CCawareness * (1 - DemocraticValue)))]
    set j j + 1
  ]
end
    
to emitGHG
  set GHG 0
  ask persons [
    set GHG GHG + (1 - CCawareness - ReductionPolicy)
    set cumulativeghg (cumulativeghg + (1 - CCawareness - ReductionPolicy))]
  ask governments [
    set GHG GHG + ((1 - PoliticalPreference - ReductionPolicy) * (#persons / #governments / RatioLocalEmissionNationalEmission - #persons / #governments))
    set cumulativeghg (cumulativeghg + ((1 - PoliticalPreference - ReductionPolicy) * (#persons / #governments / RatioLocalEmissionNationalEmission - #persons / #governments)))]
end

to negotiations
  if (ticks mod YearsbetweenInternationalNegotiations) = 0 [
    ask governments [
      set Internationalpreferencelist lput politicalpreference internationalpreferencelist
      set OpinionDifference ((max Internationalpreferencelist) - (min Internationalpreferencelist))
      set ChanceForSucces mean internationalpreferencelist - (OpinionDifference * ImportanceOpinionDifference)
      if ChanceForSucces > random-float 1 [set ReductionPolicy (ReductionPolicy + ReductionPolicyImpact)]
    ]
  ]
end

to determineCumulativeMitigation
  set cumulativemitigation 0
  ask persons [set cumulativemitigation (cumulativemitigation + CCawareness + ReductionPolicy)]
  ask governments [set cumulativemitigation (cumulativemitigation + (politicalpreference + ReductionPolicy) * (#persons / #governments / RatioLocalEmissionNationalEmission - #persons / #governments))]
end
@#$#@#$#@
GRAPHICS-WINDOW
1255
10
1674
450
16
16
12.4
1
10
1
1
1
0
0
0
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
15
55
78
88
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
15
165
187
198
#persons
#persons
0
500
40
1
1
NIL
HORIZONTAL

SLIDER
105
265
197
298
Vision1
Vision1
0
100
15
5
1
NIL
HORIZONTAL

SLIDER
105
300
197
333
Vision2
Vision2
0
100
80
5
1
NIL
HORIZONTAL

SLIDER
105
335
197
368
Vision3
Vision3
0
100
30
5
1
NIL
HORIZONTAL

SLIDER
105
370
197
403
Vision4
Vision4
0
100
30
5
1
NIL
HORIZONTAL

TEXTBOX
20
675
365
765
Explanations *\n1. Vision of governments on climate change impact [Years]\n2. Average Vision of Citizens on Climate Change Impact [Years]\n3. Democratic Value of governments, indicating the weight that individuals have in expressing their political preference [Factor 0-1]\n4. Standard deviation of vision distribution among citizens [Years]\n
11
94.0
1

BUTTON
80
55
145
88
NIL
go\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
15
200
187
233
#governments
#governments
0
10
4
1
1
NIL
HORIZONTAL

SLIDER
105
405
197
438
Vision5
Vision5
0
100
0
5
1
NIL
HORIZONTAL

SLIDER
105
440
197
473
Vision6
Vision6
0
100
0
5
1
NIL
HORIZONTAL

SLIDER
105
475
197
508
Vision7
Vision7
0
100
0
5
1
NIL
HORIZONTAL

SLIDER
105
510
197
543
Vision8
Vision8
0
100
0
5
1
NIL
HORIZONTAL

SLIDER
105
545
197
578
Vision9
Vision9
0
100
0
5
1
NIL
HORIZONTAL

SLIDER
105
581
197
614
Vision10
Vision10
0
5
0
5
1
NIL
HORIZONTAL

SLIDER
15
20
187
53
AmountOfYears
AmountOfYears
0
100
100
1
1
NIL
HORIZONTAL

BUTTON
145
55
210
88
go
while [ticks < AmountOfYears] [go]
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
805
110
885
155
Year
ticks + 2000
17
1
11

PLOT
400
20
600
170
Cumulative GHG
Time
Cumulative GHG
0.0
100.0
0.0
100.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy ticks cumulativeghg"

MONITOR
1030
375
1110
420
NIL
BAUemission
0
1
11

PLOT
600
20
800
170
GHG
Time
GHG
0.0
100.0
0.0
100.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "if ticks > 1 [plot GHG]"

MONITOR
805
20
885
65
GHG reduction
1 - (ghg / (InitBAUemission / AmountOfYears))
2
1
11

MONITOR
805
65
885
110
cGHG reduction
1 - cumulativeghg / InitBAUemission
2
1
11

BUTTON
80
90
145
123
2050
while [ticks < 50] [go]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
15
90
77
123
2020
while [ticks < 20] [go]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
145
90
210
123
2080
while [ticks < 80] [go]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
395
265
570
298
YearsBetweenInternationalNegotiations
YearsBetweenInternationalNegotiations
0
100
40
10
1
NIL
HORIZONTAL

MONITOR
400
175
500
220
Cumulative GHG
cumulativeghg
0
1
11

SLIDER
400
485
570
518
RatioLocalEmissionNationalEmission
RatioLocalEmissionNationalEmission
0
1
0.4
.01
1
NIL
HORIZONTAL

PLOT
945
425
1240
650
Climate Change Impact as a function of Cumulative GHG
Expected Cumulative GhG (/1000)
Climate Change Impact
0.0
1.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy cumghg impact"

SLIDER
945
340
1120
373
ExpFactor
ExpFactor
1.01
2
1.12
.01
1
NIL
HORIZONTAL

MONITOR
945
375
1025
420
NIL
InitBAUemission
17
1
11

MONITOR
600
175
700
220
NIL
ghg
0
1
11

TEXTBOX
1090
655
1240
735
Moet er een waarde komen waarbij, als klimaatverandering eenmaal die impact heeft, iedereen zijn emissie met 100% reduceert?
11
0.0
1

SLIDER
945
655
1060
688
ImpactFactor
ImpactFactor
0
1
1
.1
1
NIL
HORIZONTAL

MONITOR
575
265
682
310
NIL
ChanceForSucces
2
1
11

SLIDER
395
300
570
333
ImportanceOpinionDifference
ImportanceOpinionDifference
0
1
0.2
.05
1
NIL
HORIZONTAL

TEXTBOX
400
245
550
263
International negotiations\n
11
94.0
1

SLIDER
395
335
570
368
ReductionPolicyImpact
ReductionPolicyImpact
0
1
0.05
.05
1
NIL
HORIZONTAL

SLIDER
395
370
570
403
EffectInternationalPolicyOnIndividuals
EffectInternationalPolicyOnIndividuals
0
1
1
1
1
NIL
HORIZONTAL

SLIDER
395
405
570
438
EffectInternationalPolicyOnNationalPolicy
EffectInternationalPolicyOnNationalPolicy
0
1
1
1
1
NIL
HORIZONTAL

TEXTBOX
580
315
820
510
International negotiations are held every predetermined amount of years. The larger the political preference of the population, the larger the chance for a succesful outcome of the negotiations. However, if the difference in political preference between countries is too big, the chance for succesful negotiations decreases. This importance of this effect can be determined.\n\nA succesful negotiation increases the ghg reduction measures taken. The effect of such an international agreement can differ between individual mitigation measures and national mitigation measures.
11
94.0
1

TEXTBOX
1255
455
1595
676
An assumption of this model is that the impact of climate change is a function of the cumulative ghg emissions. The impact of climate change ranges from 0 to 1, which implies that the impact is 1 in the year 2100 when no mitigation actions are taken. \n\nAgents have a certain vision, which means that they can predict the cumulative ghg emissions at the business as usual (bau) rate, the rate at which they emit ghg at that moment in time, over a certain amount of years. They use this graph to assess the impact of climate change, which influences their climate change awareness.\n\nThe shape of the exponential curve can be changed by using the ExpFactor. The ImpactFactor can be used to assign a cumulative ghg to the climate change impact of 0.
11
94.0
1

PLOT
945
20
1145
170
Cumulative Mitigation Actions
Time
NIL
0.0
100.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy ticks (cumulativemitigation / (#persons + #persons / RatioLocalEmissionNationalEmission))"

TEXTBOX
945
175
1150
326
Ik wil misschien de efficientie van mitigation actions laten veranderen over de tijd. Aan de ene kant neemt het af doordat quick wins als eerste worden gedaan. Aan de andere kant kunnen technologische doorbraken de efficientie weer verhogen. Dit zou een onzekerheid kunnen zijn.
11
0.0
1

SLIDER
395
715
582
748
ChanceOfClimateDisaster
ChanceOfClimateDisaster
0
1
0.01
.01
1
NIL
HORIZONTAL

TEXTBOX
400
520
575
705
The total ghg emissions consists of individual emissions and national controlled emissions. The difference is made because individuals are able to change their individual emissions (placing a PV panel on their rooftop), but are only indirecly able to change national emissions (changing the electricity system) by means of expressing their political preference. The ratio between emissions that individuals can directly control can be changed.
11
94.0
1

SLIDER
395
750
585
783
SeverityOfClimateChangeDisaster
SeverityOfClimateChangeDisaster
0
1
0.05
.05
1
NIL
HORIZONTAL

TEXTBOX
395
785
600
866
Ik wil misschien klimaatrampen meenemen, die (tijdelijk) de awareness van climate change kunnen verhogen. Een voorbeeld van onzekerheid en bounded rationality.
11
0.0
1

TEXTBOX
775
640
925
846
Ideeën\n\nNegotiation power landen; emissieprofielen\n\nMisschien een soort risk perceptie aan agenten geven: de agent gaat niet meer extra investeren in mitigation als de gevolgen van klimaatverandering, dus de cumulatieve ghg, een bepaalde hoogte aannemen. Wanneer dit is verschilt per agent.
11
0.0
1

MONITOR
300
255
370
300
Climate Change Awareness 1
mean [CCawareness] of persons with [countrycode = 1]
2
1
11

MONITOR
300
290
370
335
Climate Change Awareness 2
mean [CCawareness] of persons with [countrycode = 2]
2
1
11

MONITOR
300
325
370
370
Climate Change Awareness 3
mean [CCawareness] of persons with [countrycode = 3]
2
1
11

MONITOR
300
360
370
405
Climate Change Awareness 4
mean [CCawareness] of persons with [countrycode = 4]
2
1
11

MONITOR
300
395
370
440
Climate Change Awareness 5
mean [CCawareness] of persons with [countrycode = 5]
2
1
11

MONITOR
300
430
370
475
Climate Change Awareness 6
mean [CCawareness] of persons with [countrycode = 6]
2
1
11

MONITOR
300
465
370
510
Climate Change Awareness 7
mean [CCawareness] of persons with [countrycode = 7]
17
1
11

MONITOR
300
500
370
545
Climate Change Awareness 8
mean [CCawareness] of persons with [countrycode = 8]
2
1
11

MONITOR
300
530
370
575
Climate Change Awareness 9
mean [CCawareness] of persons with [countrycode = 9]
2
1
11

MONITOR
300
570
370
615
Climate Change Awareness 10
mean [CCawareness] of persons with [countrycode = 10]
2
1
11

MONITOR
705
175
805
220
Climate Change Awareness
mean [CCawareness] of persons
2
1
11

SLIDER
15
625
107
658
SDVisionDistribution
SDVisionDistribution
0
20
10
1
1
NIL
HORIZONTAL

SLIDER
10
265
102
298
VisionCountry1
VisionCountry1
0
100
50
5
1
NIL
HORIZONTAL

SLIDER
10
300
102
333
VisionCountry2
VisionCountry2
0
100
10
5
1
NIL
HORIZONTAL

SLIDER
10
335
102
368
VisionCountry3
VisionCountry3
0
100
40
5
1
NIL
HORIZONTAL

SLIDER
10
370
102
403
VisionCountry4
VisionCountry4
0
100
30
5
1
NIL
HORIZONTAL

SLIDER
10
405
102
438
VisionCountry5
VisionCountry5
0
100
0
5
1
NIL
HORIZONTAL

SLIDER
10
440
102
473
VisionCountry6
VisionCountry6
0
100
0
5
1
NIL
HORIZONTAL

SLIDER
10
475
102
508
VisionCountry7
VisionCountry7
0
100
0
5
1
NIL
HORIZONTAL

SLIDER
10
510
102
543
VisionCountry8
VisionCountry8
0
100
0
5
1
NIL
HORIZONTAL

SLIDER
10
545
102
578
VisionCountry9
VisionCountry9
0
100
0
5
1
NIL
HORIZONTAL

SLIDER
10
580
102
613
VisionCountry10
VisionCountry10
0
100
0
5
1
NIL
HORIZONTAL

SLIDER
200
265
292
298
DemocraticValue1
DemocraticValue1
0
1
0.15
.05
1
NIL
HORIZONTAL

SLIDER
200
300
292
333
DemocraticValue2
DemocraticValue2
0
1
0.6
.05
1
NIL
HORIZONTAL

SLIDER
200
335
292
368
DemocraticValue3
DemocraticValue3
0
1
0.5
.05
1
NIL
HORIZONTAL

SLIDER
200
370
292
403
DemocraticValue4
DemocraticValue4
0
1
0.55
.05
1
NIL
HORIZONTAL

SLIDER
200
405
292
438
DemocraticValue5
DemocraticValue5
0
1
0.1
.05
1
NIL
HORIZONTAL

SLIDER
200
440
292
473
DemocraticValue6
DemocraticValue6
0
1
0.1
.05
1
NIL
HORIZONTAL

SLIDER
200
475
292
508
DemocraticValue7
DemocraticValue7
0
1
0.1
.05
1
NIL
HORIZONTAL

SLIDER
200
510
292
543
DemocraticValue8
DemocraticValue8
0
1
0.1
.05
1
NIL
HORIZONTAL

SLIDER
200
545
292
578
DemocraticValue9
DemocraticValue9
0
1
0.1
.05
1
NIL
HORIZONTAL

SLIDER
200
580
292
613
DemocraticValue10
DemocraticValue10
0
1
0.1
.05
1
NIL
HORIZONTAL

TEXTBOX
55
245
70
263
1*
11
94.0
1

TEXTBOX
150
245
165
263
2*
11
94.0
1

TEXTBOX
245
245
260
263
3*
11
94.0
1

TEXTBOX
115
635
130
653
4*
11
94.0
1

TEXTBOX
20
145
170
163
Agent settings\n
11
94.0
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

orbit 6
true
0
Circle -7500403 true true 116 11 67
Circle -7500403 true true 26 176 67
Circle -7500403 true true 206 176 67
Circle -7500403 false true 45 45 210
Circle -7500403 true true 26 58 67
Circle -7500403 true true 206 58 67
Circle -7500403 true true 116 221 67

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
1
@#$#@#$#@
