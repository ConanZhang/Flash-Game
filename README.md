###GOAL

Scavenge for randomly dropped ammo and avoid randomly spawning enemies for as long as you can!

###KEYBOARD CONTROLS

####MOVEMENT

* W - Jump/Double Jump/Hover
* A - Left
* S - Fall faster
* D - Right

####ABILITIES
* Space - Slow motion/Invulnerability

####WEAPON SWITCHING
* Q or E - Change weapon
* 1 - Pistol
* 2 - Shotgun
* 3 - Machine Gun

####OPTIONS
* P or R - Pause
* F - Full Screen **(FLASH 11.3 OR HIGHER!!!)**
* C - Quality: High -> Low -> Medium -> High
* Z - Turn rain on or off
* X - Show debug

####MOUSE CONTROLS

* Cursor - Aim
* Left Click - Shoot
* Scroll - Change weapon

###BOX2D

####COLLISION FILTERING

1. Enemies
  * FlyingEnemy: Collides with other flying enemies, bullets, platforms, and player. NOT platform enemies. 
    * CategoryBit: 8 
    * MaskBit: 15 (8(Self)+4(Bullet)+2(Platforms)+1(Player))
  * PlatformEnemy: Collides with bullets, platforms and player. NOT flying enemies OR platform enemies. 
    * CategoryBit: 16 
    * MaskBit: 7 (4(Bullet)+2(Platforms)+1(Player))
  * PlatformEnemySensors: Only collides with platforms. 
    * CategoryBit: 32 
    * MaskBit: 2 (2(Platforms))
  * DeadEnemy: Only collides with platforms. 
    * MaskBit: 2 (2(Platforms))
  * Spikes: Only collides with player. 
    * Category Bit: 2 
    * MaskBit: 1 (1(Player))

2. Player
  * Player: Collides with everything. 
    * CategoryBit: 1 
    * MaskBit: 0xFFFF
  * ItemDrop: Is sensor, but only collides with player. 
    * CategoryBit: 1 
    * MaskBit: 1 (1(Player))
  * Bullet: Collides with platforms and enemies. 
    * Category Bit: 4 
    * MaskBit: 26 (8(FlyingEnemy)+16(PlatformEnemy)+2(Platforms))
  * Platform: Collides with everything. 
    * CategoryBit: 2 
    * MaskBit: 0xFFFF

3. Misc.
  * Weapon: Collides with nothing. 
    * CategoryBit: 1 
    * MaskBit: 0
  * Background: Collides with nothing. 
    * CategoryBit: 1 
    * MaskBit: 0
