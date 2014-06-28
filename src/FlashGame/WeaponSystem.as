package FlashGame
{
	public class WeaponSystem
	{
		/**Class member variables*/
		public var weaponData:Array;//2D array of weapon data
		public var currentWeapon:int;
		
		/**Constructor*/
		public function WeaponSystem(defaultWeapon:int)
		{
			//initiate 2D array		Pistol		Shotgun
			weaponData = new Array(new Array(4),new Array(4) );
			
			/**
			 *	First row: Weapon Name
			 *  Second row: Starting weapon ammo
			 *  Third row: Weapon width
			 *  Fourth row: Weapon height
			 */  
			//first row: weapon name
			weaponData[0][0] = "Pistol";
			weaponData[1][0] = "Shotgun";
			
			//second row: beginning weapon ammo
			weaponData[0][1] = 10;
			weaponData[1][1] = 5;
			
			//third row:weapon width
			weaponData[0][2] = 2;
			weaponData[1][2] = 3;
			
			//fourth row:weapon height
			weaponData[0][3] = 1;
			weaponData[1][3] = 2;
			
			//set default weapon
			currentWeapon = defaultWeapon;
		}
	}
}