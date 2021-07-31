# **A3-BFT**
Some scripts to keep track of your teams. Requires DUI and ACE3.

## **How to use**
To add this to your mission, just [download](https://github.com/Jaccodouma/A3-BFT/archive/refs/heads/master.zip) the ZIP on the homepage and copy "initPlayerLocal.sqf" and the "BFT" folder into your mission. 
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
  - Update the color icons in ACE interact to actually match the colors. 
- Player markers
  - Ace incapacitated people don't show up (Might be cause they're CIV, fix later? (: )
  - Follow DUI font setting
  - Add setting to zeus to enable/disable their marker. Right now it'll never mark zeus. 
- Troop overview
  - A tab on the map with all teams/units

In the end I intend to make this into an actual mod, using CBA settings for scale etc, maybe adding settings to the menus of the editor & zeus. We'll see if i get to it. 
