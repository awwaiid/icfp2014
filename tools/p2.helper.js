function runGame() {
    broken = false;
    runLoop();
}
var first = true;
function runLoop() {
    if (first) {
        console.log("\n");
    }
    first = false;
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
    console.log("\nInitial State:\n");
    printState();
    if (state.error != null) {
        console.log('Error: " + state.error');
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
        //+ state.board + "\ngame board: "
        //+ "\n" + state.gameboard + "\n";
    var trace = '';
    if (state.traceval != null) {
        for (var index = 0; index < state.traceval.length; ++index) {
            trace = trace + state.traceval[index];
        }
        statestr = statestr + trace;
    }
    
    console.log(statestr);
    console.log("------");
    console.log(formatBoard(state.board, state.gameboard));
    console.log("------");
}

function formatBoard(board, gameboard) {

    var y = board.length;
    var x = board[0].length;
    var map ={0:'#',1:' ',2:'.',3:'o',4:'F',5:'\\',6:'/',7:'=',8:'=',9:'=',10:'=',11:'=',12:':'};
    var outStr = '';
    for (var j = 0; j < y; j++) {
        for (var i = 0; i < x; i++) {
            var charAt = i + (y * j);
            var tileNo = board[j][i];
            //console.log (i + " " + j + " " + tileNo + " " + map[tileNo]);
            //console.log (i + " " + j + " " + charAt + " " + gameboard.charAt(charAt));
            outStr = outStr + map[tileNo];            
        }
        outStr = outStr + "\n";
    }
    return outStr;
}
