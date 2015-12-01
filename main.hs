module Main where

import System.Environment
import Control.Exception
import Control.Monad
import System.IO
import System.IO.Error 
import Data.List.Split as Split
import CmdLineOptions as CmdLineOptions
import Fcm as Fcm

main :: IO()
main = do
    options <- CmdLineOptions.parseArgs
    readCSVFile options `catch` handler

readCSVFile :: Options -> IO()
readCSVFile options = do
    withFile (input options) ReadMode(\handle -> 
        do
            hSetEncoding handle utf8_bom
            contents <- hGetContents handle
            result <- try $ Fcm.exec (startAttachment options)
                                     (isHamming options)
                                     (numCluster options)
                                     (accuracy options)
                                     (stringToDouble (applyParams (ignoreFirstLine options) 
                                                     (ignoreFirstColumn options)
                                                     (ignoreLastColumn options)
                                                     (parseMatrix (delimiter options) (lines contents)))) :: IO(Either SomeException [[Double]])
            case result of
                Left e -> putStrLn $ show e
                --Prelude.putStrLn "Oops. Some strings in file"
                Right ar -> outputData (output options) ar
        )

outputData :: String -> [[Double]] -> IO()
outputData outputFile dataOut = do
            if outputFile /= "" then
                mapM_ (\line -> writeFile outputFile $ (show line) ++ "\n") dataOut
            else
                mapM_ print dataOut
        
applyParams :: Bool -> Bool -> Bool -> [[String]] -> [[String]]
applyParams ignFirstLine ignFirstColumn ignLastColumn matrix = do 
    _ignoreFirstLine ignFirstLine $ _ignoreFirstColumn ignFirstColumn $ _ignoreLastColumn ignLastColumn matrix
    

parseMatrix :: [Char] -> [String] -> [[String]]
parseMatrix delimiter content = do
    parseLine (length content) content []
    where
        parseLine count input matrix
            | count <= 0     = matrix
            | otherwise = do
                parseLine (count - 1) (tail input) ( matrix ++ [Split.splitOn delimiter (head input)]) 

--list of strings to list of doubles                
stringToDouble :: [[String]] -> [[Double]]
stringToDouble inM = 
        map (\line -> do if (line /= []) then (map read line) else (return 0)) inM
                              
_ignoreFirstLine :: Bool -> [[String]] -> [[String]]
_ignoreFirstLine True matrix = tail matrix                
_ignoreFirstLine _ matrix = matrix                

_ignoreFirstColumn :: Bool -> [[String]] -> [[String]]
_ignoreFirstColumn True matrix = map (\line -> tail line) matrix                
_ignoreFirstColumn _ matrix = matrix                

_ignoreLastColumn :: Bool -> [[String]] -> [[String]]
_ignoreLastColumn True matrix = map (\line -> init line) matrix                
_ignoreLastColumn _ matrix = matrix                

handler :: IOError -> IO()
handler e
    | isDoesNotExistError e = putStrLn "Oops. File wasn't found."
    | otherwise = ioError e  