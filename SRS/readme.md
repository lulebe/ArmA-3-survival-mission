# SRS (Simple Revive Script) for Arma3

## by Monsoon

This script is designed with simplicity and functionality in mind.  There is no AI support or single player support, only good 'ol multiplayer same-side revive support.  If the script happens to bug out, an individual can simply reset SRS on the fly.

### Current Features
* Ability to revive or drag fallen teamates
* Units do not *die* unless they suicide before their revive timer expires
* Medics revive at a faster rate than non-medics
* Option to mute TFAR/ACRE radios
* Option to add markers to the map for the fallen
* Option to add 3D icons on fallen units within 30m
* Scroll-wheel action item to reset the entire ``SRS`` system on an individual basis
* JIP support (I hope!)

### Installation
To include this script in your mission, add the following lines to your ``description.ext``:

    #include "SRS\GUI\SRSdialogs.hpp"
    class RscTitles {
    	#include "SRS\GUI\SRSprogressBar.hpp"
    };
    class CfgFunctions {
    	#include "SRS\CfgFunctions.hpp"
    };
    
And this entry in your ``init.sqf`` so that it will execute on all clients:

    [] spawn SRS_fnc_init;
    
-----

Credit and inspiration for much o this work goes out to these excellent community made revive scripts:

* [AIS wounding](http://forums.bistudio.com/showthread.php?170975-A3-Wounding-System)
* [BTC Revive](http://forums.bistudio.com/showthread.php?148085-BTC-Revive)
* [FAR Revive](http://forums.bistudio.com/showthread.php?155989-Farooq-s-Revive)
* [Grimes Simple Revive Script](http://forums.bistudio.com/showthread.php?177595-Grimes-Simple-Revive-Script)

And special thanks to Yogurt for his assistance testing ``SRS``.