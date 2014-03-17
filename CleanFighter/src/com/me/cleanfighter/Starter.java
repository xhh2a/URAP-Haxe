package com.me.cleanfighter;


import com.badlogic.gdx.Game;

public class Starter extends Game {

	@Override
	public void create() {
		setScreen(new GameScreen());
	}
}
