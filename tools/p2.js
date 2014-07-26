var system = require('system'),
    fs = require('fs');
var wasSuccessful = phantom.injectJs('game.js');
if (!wasSuccessful) {
    console.log('Could not load main game.js library');
    phantom.exit();
}
if (system.args.length != 3) {
    console.log('Not enough arguments ... ned a lambda and map instruction set');
    phantom.exit();
}

if (!fs.isReadable(system.args[1]) || !fs.isReadable(system.args[2])) {
    console.log('Couldnt read one of the input files');
    phantom.exit();
}
var lambda = fs.read(system.args[1]);
var map = fs.read(system.args[2]);
var ghost = fs.read('../bot/ghosts.ghc');
var ghosts = [ghost, ghost, ghost, ghost];
var state;
var broken;
var counter = 0;

load(lambda, map, ghosts);
printState();

runGame();

phantom.exit();

function runGame() {
    broken = false;
    runLoop();
}

function runLoop() {
    if (!broken) {
        runStep();
        runLoop();
    }
}

function runStep() {
    stepProg(state);
    if (state.gameOver == true) {
        broken = true;
        console.log('Game Over: ' + (state.gameWin ? "You Won" : "You Lost"));
    }
    else {
        printState();
    }
}


function load () {    
    state = loadGame(map, lambda, ghosts);  
    //console.log(JSON.stringify(state));
    printState();
    if (state.error != null) {
        console.log("Error: " + state.error);
    }
    else {
        console.log("Program Loaded");
    }
}

function loadGame (gameBoard, lmanProg, gs){
    var o = { gameboard: gameBoard, lmanprog: lmanProg, ghostprogs: gs };
    h$runSync( h$c2( h$ap1_e
    , h$mainZCMainziloadGameWrapper
    , h$c1(h$ghcjszmprimZCGHCJSziPrimziJSRef_con_e, o)
    )
    , false
    );
    return o;       
}

function stepProg(o){
    h$runSync( h$c2( h$ap1_e
                   , h$mainZCMainzigameStepWrapper
                   , h$c1(h$ghcjszmprimZCGHCJSziPrimziJSRef_con_e, o)
                   )
             , false
             );
}

function printState() {
    counter = counter + 1;
    //console.log(JSON.stringify(state));
    var statestr = "-----State (" + counter + ")-----\nlives: " 
        + state.lives + "\nticks: " 
        + state.ticks + "\nscore: "
        + state.score + "\nboard: "
        + state.board + "\ngame board: "
        + "\n" + state.gameboard + "\n";
    var trace = '';
    if (state.traceval != null) {
        for (var index = 0; index < state.traceval.length; ++index) {
            trace = trace + state.traceval[index];
        }
        statestr = statestr + trace;
    }
    
    console.log(statestr);
}

