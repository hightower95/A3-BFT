# **A3-BFT**
Some scripts to keep track of your teams. Requires DUI and ACE3.

## **How to use**
To add this to your mission, just download the ZIP on the homepage and copy "initPlayerLocal.sqf" and the "BFT" folder into your mission. 
Alternatively, just copy the BFT folder and add `[] execVM "BFT\init.sqf";` to some local init.

### **For mission makers**
There's three variables used:
- **BFT_marker_enable**, obvious. 
- **BFT_marker_type**, can be one of: *air, antiair, armor, art, hq, inf, installation, maint, mech_inf, med, mortar, motor_inf, naval, ordinance, plane, recon, service, support, uav, unknown*.
- **BFT_marker_color**, found [here](https://community.bistudio.com/wiki/Arma_3:_CfgMarkerColors).

An example (in the init field of a group): 
```ts
this setVariable ["BFT_marker_enable", true];
this setVariable ["BFT_marker_type", "mech_inf"];
this setVariable ["BFT_marker_color", "ColorOrange"];
```

## **Todos:**
- Group markers
  - Allow custom names 
  - Show team info when clicking marker
  - Make markers server side, or sync updates. 
- Player markers
  - Vehicle icon colour (rn it's always white, I want it to be the right team colour or side colour if no squadmates)
  - Ace incapacitated people don't show up (Might be cause they're CIV, fix later? (: )
- Troop overview
  - A tab on the map with all teams/units