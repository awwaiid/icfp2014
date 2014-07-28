#!/bin/bash

lambda_bot=$1
map=$2
ghost=$3

mapheight=$(cat $2 | wc -l)
mapheight=`expr $mapheight + 11`

pipe=/tmp/testpipe
phantom_bin=/usr/bin/phantomjs

trap "rm -f $pipe; killall tail; killall phantomjs >> error.txt 2>&1; exit" EXIT

if [[ ! -p $pipe ]]; then
    mkfifo $pipe
fi

clear
echo "Start the game? [ENTER]"
read
echo "" > out.txt
tail -f $pipe | $phantom_bin >> out.txt 2> error.txt  & 

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

while : ; do
    grep -q "Program Loaded" out.txt && break
    echo -n "."
    sleep .1
done
cat out.txt | grep -v 'phantomjs' | grep -v 'undefined';
echo "" > out.txt

while true; 
do
    echo "s for step, d for debug, l for loop, a for animate, anything else for quit"; read -n 1 cmd;
    if [[ $cmd == "s" ]]
    then
        clear
        echo "runStep();" > $pipe
        while : ; do
            grep -q "State" out.txt && break
            # echo -n "."
            sleep .1
        done
        cat out.txt | grep -v 'phantomjs' | grep -v 'undefined';
        echo "" > out.txt
    elif [[ $cmd == "a" ]] 
    then
        clear
        echo "runLoop();" > $pipe
        while : ; do
            read -t 1 -n 1 key
            if [[ $key = q ]]
            then
                break
            fi
            grep -q "Game Over" out.txt && break
            watch -n .1 "echo 'press q to quit'; tail -n $mapheight out.txt;"
        done
        break
    elif [[ $cmd == "d" ]] 
    then
        while : ; do 
            grep -q "trace lambdaman" out.txt && break
            echo "" > out.txt
            clear
            echo "runStep();" > $pipe
            while : ; do
                grep -q "State" out.txt && break
                echo -n "."
                #sleep .1
            done
        clear
        tail -n $mapheight out.txt | grep -v 'phantomjs' | grep -v 'undefined';
        done
        echo "" > out.txt
        
    elif [[ $cmd == "l" ]] 
    then
        clear
        echo "runLoop();" > $pipe
        while : ; do
            #read -t 1 -n 1 key && [[$key == "q"]] && break
            grep -q "Game Over" out.txt && break
            echo $mapheight
            echo -n "."
            tail -n $mapheight -f out.txt 
            sleep .1
        done
        cat out.txt | grep -v 'phantomjs' | grep -v 'undefined';
        break
    else 
        clear
        break  
    fi
#ending while loop
done

echo "phantom.exit(0);" > $pipe
echo "Done.";
