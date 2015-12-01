module Tests where

import Fcm
import Test.HUnit
import Data.Vector as V

main :: IO()
main = do
    let test1 = TestCase (assertEqual "for (hammingDistance [0.0,0.0,0.0] [0.0,0.0,0.0])" 
                            0.0 (hammingDistance [0.0,0.0,0.0] [0.0,0.0,0.0]))
        test2 = TestCase (assertEqual "for (hammingDistance [1.0,2.0] [3.0,4.0])" 
                            10.0 (hammingDistance [1.0,-2.0] [-3.0,4.0]))
        test3 = TestCase (assertEqual "for (euclidDistance [0.0,0.0,0.0] [0.0,0.0,0.0])" 
                            0.0 (euclidDistance [0.0,0.0,0.0] [0.0,0.0,0.0]))
        test4 = TestCase (assertEqual "for (euclidDistance [2.0,2.0,2.0,2.0] [4.0,4.0,4.0,4.0])" 
                            4.0 (euclidDistance [2.0,2.0,2.0,2.0] [4.0,4.0,4.0,4.0]))
        test5 = TestCase (assertEqual "for (matrixNorm [[0.0,0.0,0.0],[0.0,0.0,0.0]] [[0.0,0.0,0.0],[0.0,0.0,0.0]])"
                            0.0 (matrixNorm [[0.0,0.0,0.0],[0.0,0.0,0.0]] [[0.0,0.0,0.0],[0.0,0.0,0.0]]))
        test6 = TestCase (assertEqual "for (matrixNorm [[1.0,2.0],[3.0,4.0]] [[5.0,6.0],[7.0,8.0]])" 
                            21.0 (matrixNorm [[25.0,9.0],[11.0,12.0]] [[4.0,11.0],[23.0,10.0]]))
        tests = TestList [test1, test2, test3, test4, test5, test6]
    runTestTT tests
    return ()
