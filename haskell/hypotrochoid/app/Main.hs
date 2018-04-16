module Main where

import Graphics.Gloss
import System.Environment
import Hypotrochoid

-- | ignore me D:
intdiv :: (Integral x, Integral y, Floating z) => x -> y -> z
intdiv x y = fromIntegral x / fromIntegral y

-- | outputs points for tusi ellipse
-- actual answer to the problem
tusiCoords :: Int -- ^ number of points to output
    -> Float -- ^ radius
    -> Float -- ^ trace radian offset 
    -> Float -- ^ trace radius offset
    -> [(Float, Float)] -- ^ tusi ellipse output pairs
tusiCoords n r ta tr = map (hypotrochoid r 0.5 ta tr) [2 * pi * intdiv x n | x<-[0..n]]

-- | gloss demo 
drawHypotrochoid :: Int -- ^ number points to trace
    -> Float -- ^ outer radius
    -> Float -- ^ inner:outer radius ratio
    -> Float -- ^ trace radius offset
    -> Float -- ^ time
    -> Picture
drawHypotrochoid n outer innerr tr time = Pictures ([outerC, innerC, tracePt, traceOffsetLine]++pts) where
    inner = innerr*outer
    r' = outer - inner
    radian = time
    outerC = Circle outer
    (innerCx, innerCy) = ((r' * cos radian), (r' * sin radian))
    innerC = Translate innerCx innerCy $ Circle (inner)
    (x,y) = hypotrochoid outer innerr 0.0 tr radian
    tracePt = Translate x y $ Color blue $ Circle 0.05
    traceOffsetLine = Color green $ Line [(innerCx, innerCy), (x, y)]
    coords = map (hypotrochoid outer innerr 0.0 tr) [2 * pi * intdiv x n | x<-[0..n]]
    pts = map (\(x,y) -> Color red $ Translate x y $ Circle 0.01) coords

-- | gloss demo 
drawTusi :: Float -> Float -> Picture
drawTusi time tr = drawHypotrochoid n outer innerr tr time where
    outer = 1.0
    innerr = 0.5
    n = 50

-- | gloss demo
-- no args: default tusi 
-- 1 arg: tusi with specified input parameter point (absolute, inner circle has radius 0.5)
-- 4 args: animate parametirzed hypochotroid (outer radius, inner:outer radius ratio, trace point, number points to draw)
-- All args must be numbers. Does no error checking.
-- for tracing and outputting points, assumes the curve has order 1 (i.e. curve loops after one full rotation)
main :: IO ()
main = do
    args <- getArgs
    if length args == 0 then mainDefault 0.5 else 
        if length args == 1 then mainDefault (read $ args !! 0) else do
            let 
                outer = read $ args !! 0
                innerr = read $ args !! 1
                tr = read $ args !! 2
                n = read $ args !! 3
            animate (InWindow "Clock" (600, 600) (20, 20)) black $ (\time -> Color white $ Scale 120 120 $ drawHypotrochoid n outer innerr tr time)

-- | gloss demo
mainDefault :: Float -> IO ()   
mainDefault tr = do
    putStrLn "tusi coords:"
    putStrLn $ show $ tusiCoords 50 1 0 tr
    animate (InWindow "Clock" (600, 600) (20, 20)) black $ (\time -> Color white $ Scale 120 120 $ drawTusi time tr)