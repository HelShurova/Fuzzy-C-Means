# Fuzzy-C-Means
Лабораторная работа №1 – Кластеризация методом нечетких c-средних (fuzzy c-means)

Выполнила: Шурова Елена, группа 151003.

# Параметры
```bash
Usage: main [OPTION...]
  -d DELIMITER           --delimiter=DELIMITER            delimiter of attributes of objects in csv file (DEFAULT = ",")
  -h                     --ignoreFirstLine                ignore first line - as it can be a header (DEFAULT = "False")
  -f                     --ignoreFirstColumn              ignore first column - lines can be numbered (DEFAULT = "False")
  -l                     --ignoreLastColumn               ignore last column - it can be class marker (DEFAULT = "False")
  -i INPUT_FILE          --inputFile=INPUT_FILE           input csv file with objects (DEFAULT = "files/butterfly.txr")
  -o OUTPUT_FILE         --outputFile=OUTPUT_FILE         output file with matrix of belongings (DEFAULT = "")
  -a ACCURACY            --accuracy=ACCURACY              accuracy of calculation (DEFAULT = "0.01")
  -n NUMBER_OF_CLUSTERS  --numCluster=NUMBER_OF_CLUSTERS  number of clusters (DEFAULT = "6")
  -m                     --isHamming                      true - for hamming distance, false(default) - euclide distance
  -s                     --startAttachment                true - start with calculating matrix of belongings, false(default) - start with random centres
```
# Компиляция и запуск
```bash
ghc --make main
runhaskell main -l -o output.txt

Запустить тесты:
runhaskell test
```
