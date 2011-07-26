#!/bin/bash
  
clear

echo "TestYii 1.0.0 by Evan Frohlich, Matteo Rinaudo and Eric McGill"

case "$1" in
  "both") testType=""
  ;;
  "unit") testType="unit"
  ;;
  "functional") testType="functional"
  ;;
  "") testType="unit"
  ;;
esac

if [ "$2" ]; then
  webapp="$2"
else
  webapp="$2"
fi

function runTests {
  touch ./TestYii.tmp
  cd ../$webapp/protected/tests
  phpunit ./$testType | tee ../../../TestYii/lastTestOutPut.log
  result=`tail -n 1 ../../../TestYii/lastTestOutPut.log`

  if [ `echo "$result" | grep "OK" | grep -v grep | wc -l` -gt 0 ]; then
    imagePath="../../../TestYii/images/pass.png"
    result="Active! $result"
  else
    imagePath="../../../TestYii/images/fail.png"
    result="Frail! $result"
  fi
  growlnotify -n TestYii -m $result -s --image $imagePath
  cd ../../../TestYii
}

if [ -f ./TestYii.tmp ]; then
  fileExists=1
  #echo "filexits"
else
  runTests
  #echo "no file"
fi



while [ "1" == "1" ]
do
  if [ `find ../$webapp -type f -newer TestYii.tmp | wc -l` -gt 0 ]; then
    runTests
  fi
  sleep 5
done
