#!/bin/bash

drt=5.0 

glmark2-es2-wayland \
-b build:use-vbo=false:duration=$drt \
-b texture:texture-filter=nearest:duration=$drt \
-b shading:shading=gouraud:duration=$drt \
-b bump:bump-render=high-poly:duration=$drt \
-b effect2d:kernel=0,1,0:duration=$drt \
-b pulsar:light=false:quads=5:texture=false:duration=$drt \
-b desktop:blur-radius=5:effect=blur:passes=1:separable=true:windows=4:duration=$drt \
-b buffer:columns=200:interleave=false:update-dispersion=0.9:update-fraction=0.5:update-method=map:duration=$drt \
-b ideas:duration=$drt:speed=duration \
-b jellyfish:duration=$drt \
-b terrain:duration=$drt \
-b shadow:duration=$drt \
-b refract:duration=$drt \
-b conditionals:fragment-steps=0:vertex-steps=0:duration=$drt \
-b function:fragment-complexity=low:fragment-steps=5:duration=$drt \
-b loop:fragment-loop=false:fragment-steps=5:vertex-steps=5:duration=$drt 

