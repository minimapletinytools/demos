# hypotrochoid

## tusi
this app contains functionality for animating and outputting paramterized hypotrochoids. You can configure some default cases via command line args. For full configuration, please use hypotrochoid module.

running:
```tusi 0.5```
outputs tusi curve points from tracing at radius 0.5 with outer radius 1. Also animates using gloss.

running:
```tusi 1 0.2 0.3 100 ```
animates hypotrochoid with outer radius 1, inner:outer radius 0.2, tracing at 0.3, with 100 sampling points.

This will not output points. Sample point parameter is for gloss animation only. Sampling assumes 1 cycle, i.e. the curve must loop after 1 full rotation. You can have non 1-cycles, and it will ony trace the first rotation. You can supply negative inner:outer radius ratios to trace from outside. 
