package com.me.cleanfighter;


import world.World;
import world.WorldController;

import com.badlogic.gdx.Application.ApplicationType;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.Input.Keys;
import com.badlogic.gdx.InputProcessor;
import com.badlogic.gdx.Screen;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.math.Vector2;

public class GameScreen implements Screen, InputProcessor {

	private World 			world;
	private WorldRenderer 	renderer;
	private WorldController	controller;
	
	private int width, height;
	
	@Override
	public void show() {
		world = new World();
		renderer = new WorldRenderer(world, true);
		controller = new WorldController(world);
		Gdx.input.setInputProcessor(this);
		
		///HARDCODED TESTS
		//Poop poop = new Poop();
		//poop.position = new Vector2(300,50);
		//poop.receiveForce(new Vector2(-40,0));
		//world.addEnemy(poop);
	}

	@Override
	public void render(float delta) {
		Gdx.gl.glClearColor(0.1f, 0.1f, 0.1f, 1);
		Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);

		controller.update(delta);
		renderer.render();
	}
	
	@Override
	public void resize(int width, int height) {
		renderer.setSize(width, height);
		this.width = width;
		this.height = height;
	}

	@Override
	public void hide() {
		Gdx.input.setInputProcessor(null);
	}

	@Override
	public void pause() {
		// TODO Auto-generated method stub
	}

	@Override
	public void resume() {
		// TODO Auto-generated method stub
	}

	@Override
	public void dispose() {
		Gdx.input.setInputProcessor(null);
	}

	// * InputProcessor methods ***************************//

	@Override
	public boolean keyDown(int keycode) {
		if (keycode == Keys.LEFT)
			controller.leftPressed();
		if (keycode == Keys.RIGHT)
			controller.rightPressed();
		if (keycode == Keys.UP)
			controller.upPressed();
		if (keycode == Keys.DOWN)
			controller.downPressed();
		if (keycode == Keys.SPACE)
			controller.firePressed();
		return true;
	}

	@Override
	public boolean keyUp(int keycode) {
		if (keycode == Keys.LEFT)
			controller.leftReleased();
		if (keycode == Keys.RIGHT)
			controller.rightReleased();
		if (keycode == Keys.DOWN)
			controller.downReleased();
		if (keycode == Keys.UP)
			controller.upReleased();
		if (keycode == Keys.SPACE)
			controller.fireReleased();
		return true;
	}

	@Override
	public boolean keyTyped(char character) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean touchDown(int x, int y, int pointer, int button) {
		if (!Gdx.app.getType().equals(ApplicationType.Android))
			return false;
		if (x < width / 3) {
			controller.leftPressed();
		}
		if (x > 2*width / 3) {
			controller.rightPressed();
		}
		
		if (y < height/3){
			//TODO: Fix these ups and downs 
			controller.upPressed();
		}
		if (y > 2*height/3){
			controller.downPressed();
		}
		
		return true;
	}

	@Override
	public boolean touchUp(int x, int y, int pointer, int button) {
		if (!Gdx.app.getType().equals(ApplicationType.Android))
			return false;
		if (x < width / 3) {
			controller.leftReleased();
		}
		if (x > 2*width / 3) {
			controller.rightReleased();
		}
		
		if (y < height/3){
			
			controller.upReleased();
		}
		if (y > 2*height/3){
			controller.downReleased();
		}
		
		return true;
	}

	@Override
	public boolean touchDragged(int x, int y, int pointer) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean scrolled(int amount) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean mouseMoved(int screenX, int screenY) {
		// TODO Auto-generated method stub
		return false;
	}
	

}
