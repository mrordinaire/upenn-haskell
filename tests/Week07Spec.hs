module Week07Spec where

import Data.Vector as V
import Test.Hspec
import Week07

spec :: Spec
spec = do
  describe "liftM" $
    it "should work" $ do
      liftM (+1) (Just 5) `shouldBe` Just 6
      liftM (+1) Nothing  `shouldBe` Nothing

  describe "swapV" $
    it "should work" $ do
      swapV 0 2 (V.fromList [1,2,3]) `shouldBe` Just (V.fromList [3,2,1])
      swapV 0 2 (V.fromList [1,2])   `shouldBe` Nothing

  describe "mapM" $
    it "should work" $ do
      Week07.mapM Just [1..10]                 `shouldBe` Just [1..10]
      Week07.mapM id [Just 1, Just 2, Nothing] `shouldBe` Nothing

  describe "getElts" $
    it "should work" $ do
      getElts [1,3] (V.fromList [0..9])  `shouldBe` Just [1, 3]
      getElts [3,1] (V.fromList [0..9])  `shouldBe` Just [3, 1]
      getElts [1,10] (V.fromList [0..9]) `shouldBe` Nothing
      getElts [10,1] (V.fromList [0..9]) `shouldBe` Nothing
