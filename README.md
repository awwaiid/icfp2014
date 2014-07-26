# icfp2014

## Team: Keep Programming Weird

## Contributors:
- borbyu
- awwaiid
- lungching

## Implementation Notes

We built a LISP translator in perl, which uses regexes to transform LISP into perl data structures and then traverses those. We also adapted the online reference implementation of the game engine into a local command line tool to ease testing.

### How to run a bot
- Compile: ./tools/lambda.pl bot/wallfollow.lisp > out.gcc
  - Or: ./tools/lambda.pl bot/wallfollow.lisp | xclip ; paste into web
- Run: phantomjs tools/p2.js out.gcc maps/world-classic.txt

### Bot LISP
- Libraries are in bot/lib/

