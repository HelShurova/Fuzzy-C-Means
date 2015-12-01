module Fcm(exec, hammingDistance, euclidDistance, matrixNorm) where

import System.Environment
import System.Random
import Data.List

exec :: Bool -> Bool -> Int -> Double -> [[Double]] -> IO[[Double]]
exec startAttachment isHamming clusterNumber accuracy objectMatrix = 
    iterationCycle (initAttachmentMatrix objectMatrix startAttachment isHamming clusterNumber) 
    where
        iterationCycle prevMatrix = do
            prev <- prevMatrix
            --new centers
            centers <- calculateCenters objectMatrix prev
            --new attachment matrix
            let nextMatrix = calculateAttachmentMatrix isHamming objectMatrix centers   
            cur <- nextMatrix
            --was set accuracy achieved
            if matrixNorm prev cur >= accuracy then iterationCycle nextMatrix
            else nextMatrix    

initAttachmentMatrix :: [[Double]] -> Bool -> Bool -> Int -> IO[[Double]]
initAttachmentMatrix objectMatrix startAttachment isHamming clusterNumber 
        --attachmentMatrix as start point
        | startAttachment      = randomMatrixAttachment (length objectMatrix) clusterNumber
        --centersMatrix as start point
        | otherwise     = do
                            randomCenters <- randomMatrixCenters objectMatrix clusterNumber
                            calculateAttachmentMatrix isHamming objectMatrix randomCenters
        

calculateCenters :: [[Double]] -> [[Double]] -> IO[[Double]]
calculateCenters objectMatrix attachmentMatrix =
        return $ iterateCalculate attachmentMatrix []
            where iterateCalculate attMatrix result = 
                    if null (head attMatrix) then result
                    else iterateCalculate (tailColumn attMatrix) (result  ++ [modifyCenter objectMatrix (headColumn attMatrix)])

modifyCenter :: [[Double]] -> [Double] -> [Double]
modifyCenter objectMatrix attachmentMatrixLine = do  
        let
            -- 2 - m - exponential weight 
            muArray = sum $ map (\row -> row ** 2) attachmentMatrixLine
            summedCenterObject = calculateSumObjectsWithWeights objectMatrix attachmentMatrixLine (randomArray $ length $ head objectMatrix)
        map (/ muArray) summedCenterObject
        
calculateSumObjectsWithWeights :: [[Double]] -> [Double] -> [Double] -> [Double]
calculateSumObjectsWithWeights _ [] sum = sum
calculateSumObjectsWithWeights objectMatrix attachmentMatrixLine sum
      = calculateSumObjectsWithWeights (tail objectMatrix) 
                                       (tail attachmentMatrixLine)
                                       (sumTwoObjects sum $ composeObjectWithWeight (head objectMatrix) (head attachmentMatrixLine))           

composeObjectWithWeight :: [Double] -> Double -> [Double]        
composeObjectWithWeight object weight = map (\obj_i -> obj_i * (weight ** 2)) object

calculateAttachmentMatrix :: Bool -> [[Double]] -> [[Double]]-> IO[[Double]]
calculateAttachmentMatrix distanceType objectMatrix centersMatrix = do
       return $ map (\object -> calculateBeloningForOneObject distanceType object centersMatrix) objectMatrix
        

calculateBeloningForOneObject :: Bool -> [Double] -> [[Double]] -> [Double]
calculateBeloningForOneObject distanceType object centersMatrix = do
        map (\cluster -> calculateBeloningForOneObjectForCluster distanceType object cluster centersMatrix) centersMatrix 

calculateBeloningForOneObjectForCluster :: Bool -> [Double] -> [Double] -> [[Double]] -> Double        
calculateBeloningForOneObjectForCluster distanceType object clusterCenter centersMatrix = do       
        let 
            countBeloning center 
                --hammingDistance
                | distanceType      = (hammingDistance object clusterCenter / $ replaceZero (hammingDistance object center) (hammingDistance object clusterCenter)) ** 2
                --euclidDistance
                | otherwise         = (euclidDistance object clusterCenter / $ replaceZero (euclidDistance object center) (euclidDistance object clusterCenter)) ** 2
        (sum $ map (\center -> countBeloning center) centersMatrix) ** (-1)
        
--get random matrix where element sum in row equals 1  
randomMatrixAttachment :: Int -> Int -> IO[[Double]]
randomMatrixAttachment rows columns = randomMatrix rows columns []
    where
        randomMatrix rows columns matrix
            | rows <= 0    = return matrix
            | otherwise = do 
                -- generate random row with total sum 1
                row <- newStdGen >>= \stdGen -> return (Prelude.take columns (randomRs (0,1) stdGen :: [Double]))
                -- add to matrix with normalize
                randomMatrix (rows-1) columns ((Prelude.map (/ Prelude.sum row) row) : matrix)        

-- get random line from objects Matrix
-- number of rows - number of clusters   
-- don't know how to do without getting element by index            
randomMatrixCenters :: [[Double]] -> Int -> IO[[Double]]
randomMatrixCenters matrixOfObjects numberOfClusters = generateMatrixOfCenters matrixOfObjects numberOfClusters []
    where
        generateMatrixOfCenters objects count resultMatrix
            | count <= 0    = return resultMatrix
            | otherwise = do 
                -- get random row
                row <- newStdGen >>= \stdGen -> return (objects !! (fst (randomR (0, length objects - 1) stdGen)))
                -- add to result matrix
                generateMatrixOfCenters objects (count-1) (row : resultMatrix)
                
--calculate Hamming distance
hammingDistance :: [Double] -> [Double] -> Double
hammingDistance object1 object2 = 
    sum $ map abs $ zipWith (-) object1 object2                

--calculate Euclid distance
euclidDistance :: [Double] -> [Double] -> Double
euclidDistance object1 object2 = 
    sqrt $ sum $ map (\x -> x*x) $ zipWith (-) object1 object2                

--calculate matrix norm
matrixNorm :: [[Double]] -> [[Double]] -> Double
matrixNorm prevMatrix curMatrix = do
    maximum $ map abs (zipWith (-) (concat prevMatrix) (concat curMatrix))

-- sum of two objects from matrix                            
sumTwoObjects :: [Double] -> [Double] -> [Double]
sumTwoObjects object1 object2 = zipWith (+) object1 object2

--create array of size
randomArray :: Int -> [Double]
randomArray size = Prelude.take size (repeat 0)

--if  number1 = 0, set number1 = number2 - as result attachment coefficient equals 1  
replaceZero :: Double -> Double -> Double
replaceZero number1 number2 
    | number1 = 0    = number2
    | otherwise      = number1
    
--first column of 2-dimensional array
headColumn :: [[Double]] -> [Double]
headColumn matrix =
        map (\object -> head object) matrix
        
--columns of 2-dimensional array without first
tailColumn :: [[Double]] -> [[Double]]
tailColumn matrix =       
        map (\object -> tail object) matrix
        
