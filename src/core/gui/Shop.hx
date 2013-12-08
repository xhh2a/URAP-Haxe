package core.gui;

/** Bare bones class that represents the shop, which is displayed
in between levels and the player can buy upgrades.*/
class Shop {
    /** List of all upgrades to be displayed in the upgrade menu.*/
    var _upgradeList : List<Upgrade>;

    /** Adds an UPGRADE to the upgrade list.*/
    public function addUpgrade(upgrade:Upgrade):void {
        upgrades.append(upgrade);
    }

    /** Tells the character class that UPGRADE was purchased, subtracts
    the gold from the player needed to buy the upgrade, and applies
    the effects of the upgrade.*/
    public function buyUpgrade(upgrade:Upgrade):void {
        //Tell the character class that the upgrade was bought;
        //subtract the cost of the upgrade from current gold;
        //apply the upgrade to the character
    }
}
