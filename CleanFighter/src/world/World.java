package world;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;

import world.entities.*;

public class World {
	private ArrayList<Enemy> enemies = new ArrayList<Enemy>();
	private ArrayList<Projectile> projectiles = new ArrayList<Projectile>();
	private Player player;

	public World(){
		this.player = new Player();
		this.player.setWorld(this);
	}
	
	public Player getPlayer(){
		return player;
	}
	
	public void update(float delta){
		this.player.update(delta);
		for (int i=0; i<enemies.size(); i++){
			
			Enemy enemy = enemies.get(i);
			
			while (!enemy.shouldExist){
				
				this.removeEnemy(enemy);
				if (i<enemies.size())
					enemy = enemies.get(i);
				else
					break;
			}
			
			enemy.update(delta);
		}
		
		
		for (int i=0; i<projectiles.size(); i++){
			Projectile projectile = projectiles.get(i);
			
			while (!projectile.shouldExist){
				this.removeProjectile(projectile);
				
				if (i<projectiles.size())
					projectile = projectiles.get(i);
				else
					break;
			}
			
			projectile.update(delta);
			
			for (int j=0; j<enemies.size(); j++){
				Enemy enemy = enemies.get(j);
				
				if (projectile.intersects(enemy)){
					projectile.hit(enemy);
				}
			}
		}
		
		
	}

	public void drawSelf(SpriteBatch spritebatch){
		for (Enemy enemy: enemies){
			//if (enemy.isAlive())
				enemy.drawSelf(spritebatch);
		}
		for (Projectile projectile: projectiles){
			projectile.drawSelf(spritebatch);
		}
		player.drawSelf(spritebatch);
	}

	public void addProjectile(Projectile projectile) {
		this.projectiles.add(projectile);
		projectile.setWorld(this);
	}

	public void addEnemy(Enemy enemy) {
		this.enemies.add(enemy);
		enemy.setWorld(this);
	}

	private void removeEnemy(LivingObject livingObject) {
		this.enemies.remove(livingObject);
		livingObject.setWorld(null);
	}
	private void removeProjectile(Projectile projectile) {
		this.projectiles.remove(projectile);
		projectile.setWorld(null);
	}
}
