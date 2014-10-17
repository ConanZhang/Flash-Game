###GOAL

Survive for 3 minutes. Scavenge for randomly dropped ammo and avoid randomly spawning enemies!

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

###MOUSE CONTROLS

* Cursor - Aim
* Left Click - Shoot
* Scroll - Change weapon

###BOX2D

####COLLISION FILTERING

* Bullet: Collides with platforms and enemies. 
  * Category Bit: 4 
  * MaskBit: 26
* FlyingEnemy: Collides with other flying enemies, bullets, and player. NOT platform enemies. 
  * CategoryBit: 8 
  * MaskBit: 15
* PlatformEnemy: Collides bullets, platforms and player. NOT flying enemies OR platform enemies. 
  * CategoryBit: 16 
  * MaskBit: 7
* PlatformEnemySensors: Only collides with platforms. 
  * CategoryBit: 32 
  * MaskBit: 2
* DeadEnemy: Only collides with platforms. 
  * MaskBit: 2
* Spikes: Only collides with player. 
  * Category Bit: 2 
  * MaskBit: 1

* ItemDrop: Is sensor, but only collides with player. 
  * CategoryBit: 1 
  * MaskBit: 1

* Platform: Collides with everything. 
  * CategoryBit: 2 
  * MaskBit: 0xFFFF
* Player: Collides with everything. 
  * CategoryBit: 1 
  * MaskBit: 0xFFFF

* Weapon: Collides with nothing. 
  * CategoryBit: 1 
  * MaskBit: 0
* Background: Collides with nothing. 
  * CategoryBit: 1 
  * MaskBit: 0