package core.gui;

/** Class representing the heads up display, the toolbar above
the character in the game that displays the current stats of
the player.
    @author Victor Chen*/
class HeadsUpDisplay {

    /** Stores the health, gold, and current weapon of the player,
    to be displayed in the Heads up display.*/
    var _health : Null<Float>;
    var _gold : Null<Float>;
    var _currentWeapon : String;

    /** Stores a list of items to be displayed in the menu.*/
    var _menuList : List<String>;

    /** Stores the current level.*/
    var currentLevel : Level;

    /** Returns the players current health.*/
    public function getHealth():Float
    {
        return _health;
    }

    /** Returns the current amount of gold the player possesses.*/
    public function getGold():Float
    {
        return _gold;
    }

    /** Returns the current weapon.*/
    public function getCurrentWeapon():String
    {
        return _currentWeapon;
    }

    /** Returns the menuList of items in the menu.*/
    public function getMenuList():List<String>
    {
        return _menuList;
    }

    /** Sets the current health to HEALTH.*/
    public function setHealth(health:Null<Float>):void
    {
        //check that its a valid health, > 0 and < 100
        _health = health;
    }

    /** Sets the current gold to GOLD.*/
    public function setGold(gold:Null<Float>):void
    {
        //check that its a valid setting for gold, > -1
        _gold = gold;
    }

    /** Sets the current weapon to CURRENTWEAPON.*/
    public function setCurrentWeapon(currentWeapon:String):void
    {
        //check that its a valid weapon
        _currentWeapon = currentWeapon;
    }

    /** Adds MENUITEM to the menu, if it is not already present.*/
    public function addToMenu(menuItem:String):void
    {
        //add the item to the menulist
    }

    /** Removes MENUITEM from the menulist, if it is present.*/
    public function removeFromMenu(menuItem:String):void
    {
        //if menuItem is in the menu, then remove it
        //otherwise do something else
    }

    /** Updates the onscreen display when the frame updates with
    the latest state of the variables.*/
    public function onFrameUpdate() {
        var PC = level.instances.(findThePlayerCharacter)
        healthbar.size = PC._attribute.
        //set onscreen display to current state of variables
    }
}