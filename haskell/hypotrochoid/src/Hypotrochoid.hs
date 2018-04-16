module Hypotrochoid (hypotrochoid) where  

-- | change phi offset to trace tusi curve
-- angle offsets start from 3 o clock position 
hypotrochoid :: (Floating a) => a -- ^ outer radius
	-> a -- ^ inner:outer radius ratio
	-> a -- ^ trace radian offset
	-> a -- ^ trace radius offset
	-> a -- ^ phi offset
	-> (a, a) -- ^ x y coordinates
hypotrochoid r irr ta tr p = (x, y) where
	r' = r*irr -- inner radius
	x = (r-r') * cos p + tr * cos (ta - p / irr + p)
	y = (r-r') * sin p + tr * sin (ta - p / irr + p)

