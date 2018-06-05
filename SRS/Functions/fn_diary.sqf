if (isDedicated) exitWith {};

_subject = player createDiarySubject ["SRS", "SRS"];
player createDiaryRecord ["SRS",["Credits", "
<br/>
<font face='PuristaMedium' size=30 color='#ffffff'>SRS</font><br/>
<font face='PuristaMedium' size=25 color='#ffffff'>by: Monsoon</font><br/><br/>
<font face='PuristaMedium' size=18 color='#ffffff'>SRS is a simple revive script designed to be lightweight and functinoal.  It would not be possible without the inspiration from these amazing community scripts:</font><br/>
<font face='PuristaMedium' size=12 color='#ffffff'>* AIS Injury: http://www.armaholic.com/page.php?id=24088</font><br/>
<font face='PuristaMedium' size=12 color='#ffffff'>* BTC Revive: http://www.armaholic.com/page.php?id=18955</font><br/>
<font face='PuristaMedium' size=12 color='#ffffff'>* FAR Revive: http://www.armaholic.com/page.php?id=20897</font><br/>
<font face='PuristaMedium' size=12 color='#ffffff'>* Grimes: http://www.armaholic.com/page.php?id=25662</font><br/>
"]];
player createDiaryRecord ["SRS",["Usage", "
<br/>
<font face='PuristaMedium' size=16 color='#ffffff'>When a friendly unit is downed simply walk up to them and select either Revive, or Drag.  If you are classified as a medic then you will heal considerably faster.  When a unit is revived, their fatigue will be high and they will need additional medical attention from a medic.</font><br/>
"]];
player createDiaryRecord ["SRS",["Resetting", "
<br/>
<font face='PuristaMedium' size=16 color='#ffffff'>If for whatever reason SRS bugs out, simply select 'Reset SRS' from your action menu.  It will shut down and reset after ~5 seconds.</font><br/>
"]];
