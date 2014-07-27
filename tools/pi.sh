#!/bin/bash

lambda_bot=$1
map=$2
ghost=$3

pipe=/tmp/testpipe
phantom_bin=/usr/bin/phantomjs

trap "rm -f $pipe" EXIT

if [[ ! -p $pipe ]]; then
    mkfifo $pipe
fi

clear
echo "Start the game? [ENTER]"
read
echo "" > out.txt
tail -f $pipe | $phantom_bin 1>>out.txt 2> error.txt  & 
echo "var system = require('system'), fs = require('fs');" > $pipe
echo "phantom.injectJs('tools/game.js');" > $pipe
echo "phantom.injectJs('tools/p2.helper.js');" > $pipe
echo "var lambda = fs.read('$lambda_bot');" > $pipe
echo "var map = fs.read('$map');" > $pipe
echo "var ghost = fs.read('$ghost');" > $pipe
echo "var ghosts = [ghost,ghost,ghost,ghost];" > $pipe
echo "var state;" > $pipe
echo "var broken;" > $pipe
echo "var counter = 0;" > $pipe
echo "load(lambda,map,ghosts);" > $pipe

#echo "catting out"
while : ; do
    grep -q "Program Loaded" out.txt && break
    echo "."
    sleep .1
done
cat out.txt | grep -v 'phantomjs' | grep -v 'undefined';
echo "" > out.txt

while true; 
do
    echo "s for step, l for loop, anything else for quit"; read -n 1 cmd;
    if [[ $cmd == "s" ]]
    then
        clear
        echo "runStep();" > $pipe
        while : ; do
            grep -q "State" out.txt && break
            echo "."
            sleep .1
        done
        cat out.txt | grep -v 'phantomjs' | grep -v 'undefined';
        echo "" > out.txt
    elif [[ $cmd == "l" ]] 
    then
        clear
        echo "runLoop();" > $pipe
        #while ![ grep -q "Game Over" "out.txt"]; do echo "sleeping"; sleep 2; done
        while : ; do
            grep -q "Game Over" out.txt && break
            echo "."
            sleep .1
        done
        
        cat out.txt | grep -v 'phantomjs' | grep -v 'undefined';
        echo "" > out.txt
        break
    else 
        clear
        break  
    fi
#ending while loop
done

echo "phantom.exit(0);" > $pipe
echo "Done.";
