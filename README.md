# A3-BFT
Some scripts to keep track of your teams. Requires DUI and ACE3.

## How to use
To add this to your mission, just download the ZIP on the homepage and copy "initPlayerLocal.sqf" and the "BFT" folder into your mission. 
Alternatively, just copy the BFT folder and add `[] execVM "BFT\init.sqf";` to some local init.

## Todos: 
- Group markers
  - Allow custom names 
  - Show team info when clicking marker
  - Make markers server side, or sync updates. 
- Player markers
  - Vehicle icon colour (rn it's always white, I want it to be the right team colour or side colour if no squadmates)
  - Ace incapacitated people don't show up (Might be cause they're CIV, fix later? (: )
- Troop overview
  - A tab on the map with all teams/units