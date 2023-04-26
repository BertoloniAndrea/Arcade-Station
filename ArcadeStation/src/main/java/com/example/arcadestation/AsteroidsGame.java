package com.example.arcadestation;

import com.almasb.fxgl.app.GameApplication;
import com.almasb.fxgl.app.GameSettings;
import com.almasb.fxgl.dsl.FXGL;
import com.almasb.fxgl.entity.Entity;
import com.almasb.fxgl.entity.EntityFactory;
import javafx.scene.input.KeyCode;
import javafx.util.Duration;

import java.util.Map;

import static com.almasb.fxgl.dsl.FXGL.*;
import static com.example.arcadestation.AsteroidsEntityType.*;

public class AsteroidsGame extends GameApplication {

    private Entity player;
    private Entity saucer;
    private Entity bigAsteroid;

    @Override
    protected void initSettings(GameSettings gameSettings) {
        gameSettings.setWidth(1200);
        gameSettings.setHeight(800);
        gameSettings.setTitle("Asteroids");
        gameSettings.setVersion("0.1");
    }

    @Override
    protected void initInput() {
        onKey(KeyCode.W, () -> player.translateY(-2.5));
        onKey(KeyCode.A, () -> player.translateX(-2.5));
        onKey(KeyCode.S, () -> player.translateY(2.5));
        onKey(KeyCode.D, () -> player.translateX(2.5));
    }

    @Override
    protected void initGame() {
        getGameWorld().addEntityFactory(new AsteroidsGameFactory());
        player = spawn("PlayerShip");
        player.setX(600);
        player.setY(400);

        bigAsteroid = spawn("BigAsteroid");

        run(() -> {
            saucer = spawn("Saucer");
        }, Duration.seconds(15));

        run(() ->{
            bigAsteroid = spawn("BigAsteroid");
        }, Duration.seconds(60));
    }

    @Override
    protected void initGameVars(Map<String, Object> vars) {
        vars.put("score", 0);
    }

    @Override
    protected void initPhysics() {
        onCollisionBegin(PLAYER_SHIP, SAUCER, (player, saucer) -> {
            saucer.removeFromWorld();
        });
    }

    @Override
    protected void initUI() {

    }

    @Override
    protected void onUpdate(double tpf) {
        if (player.getX() < 0) {
            player.setX(1200);
        }
        if (player.getX() > 1200) {
            player.setX(0);
        }
        if (player.getY() < 0) {
            player.setY(800);
        }
        if (player.getY() > 800) {
            player.setY(0);
        }
    }

    public static void main(String[] args) {
        launch(args);
    }

}
