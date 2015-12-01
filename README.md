# Fuzzy-C-Means

Usage: main [OPTION...]
  -d DELIMITER           --delimiter=DELIMITER            delimiter of attributes of objects in csv file\n
  -h                     --ignoreFirstLine                ignore first line - as it can be a header
  -f                     --ignoreFirstColumn              ignore first column - lines can be numbered
  -l                     --ignoreLastColumn               ignore last column - it can be class marker
  -i INPUT_FILE          --inputFile=INPUT_FILE           input csv file with objects
  -o OUTPUT_FILE         --outputFile=OUTPUT_FILE         output file with matrix of belongings
  -a ACCURACY            --accuracy=ACCURACY              accuracy of calculation
  -n NUMBER_OF_CLUSTERS  --numCluster=NUMBER_OF_CLUSTERS  number of clusters
  -m                     --isHamming                      true - for hamming distance, false(default) - euclide distance
  -s                     --startAttachment                true - start with calculating matrix of belongings, false(default) - start with random centres
)
