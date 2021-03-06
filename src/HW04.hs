{-# OPTIONS_GHC -Wall #-}
module HW04 where

newtype Poly a = P [a]

-- Exercise 1 -----------------------------------------

x :: Num a => Poly a
x = P [0, 1]

-- Exercise 2 ----------------------------------------

instance (Num a, Eq a) => Eq (Poly a) where
  P p1 == P p2 = pEqual p1 p2
    where pEqual [] p            = all (== 0) p
          pEqual p []            = all (== 0) p
          pEqual (h1:t1) (h2:t2) = (h1 == h2) && pEqual t1 t2

-- Exercise 3 -----------------------------------------

instance (Num a, Eq a, Show a) => Show (Poly a) where
  show (P ts) = zeroIfEmpty . drop 3 . concatMap showTerm . reverse $ zip [0..] ts
    where showTerm (e, c) | c == 0    = ""
                          | e == 0    = " + " ++ show c
                          | otherwise =    " + "
                                        ++ (case c of
                                              1  -> ""
                                              -1 -> "-"
                                              _  -> show c)
                                        ++ (if e == 1 then "x" else "x^" ++ show e)
          zeroIfEmpty ""  = "0"
          zeroIfEmpty str = str

-- Exercise 4 -----------------------------------------

plus :: Num a => Poly a -> Poly a -> Poly a
plus (P p1) (P p2) = P $ plus' p1 p2
  where plus' (h1:t1) (h2:t2) = (h1+h2) : plus' t1 t2
        plus' [] l2 = l2
        plus' l1 [] = l1

-- Exercise 5 -----------------------------------------

times :: Num a => Poly a -> Poly a -> Poly a
times (P p1) (P p2) = sum . map P . zipWith (++) (map (flip replicate 0) [0..]) $ map (\c -> map (* c) p1) p2

-- Exercise 6 -----------------------------------------

negateP :: Num a => Poly a -> Poly a
negateP (P p) = P $ map negate p

pFromInteger :: Num a => Integer -> Poly a
pFromInteger = P . (: []) . fromInteger

instance Num a => Num (Poly a) where
    (+) = plus
    (*) = times
    negate      = negateP
    fromInteger = pFromInteger
    -- No meaningful definitions exist
    abs    = undefined
    signum = undefined

-- Exercise 7 -----------------------------------------

applyP :: Num a => Poly a -> a -> a
applyP (P p) v = sum . zipWith (*) p $ iterate (* v) 1

-- Exercise 8 -----------------------------------------

class Num a => Differentiable a where
    deriv  :: a -> a
    nderiv :: Int -> a -> a
    nderiv n v | n <= 0    = v
               | otherwise = nderiv (n-1) (deriv v)

-- Exercise 9 -----------------------------------------

instance (Num a, Enum a) => Differentiable (Poly a) where
    deriv (P p) = P . drop 1 $ zipWith (*) [0..] p
