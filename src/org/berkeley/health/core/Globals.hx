package org.berkeley.health.core;

enum Attribute {
	type;
	longname;
	shortname;
	tooltip;
	animation;
	enemypassthrough;
	friendlypassthrough;
	firetype;
	damage;
	durability;
	cost;
	range;
	firerate;
	turnrate;
	levels;
}

class Globals {
	public static function toAttribute(str) {
		return Type.createEnum(Attribute, str);
	}
}