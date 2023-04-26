package com.example.arcadestation;

import com.almasb.fxgl.dsl.components.RandomMoveComponent;
import com.almasb.fxgl.entity.Entity;
import com.almasb.fxgl.entity.EntityFactory;
import com.almasb.fxgl.entity.SpawnData;
import com.almasb.fxgl.entity.Spawns;
import javafx.geometry.Rectangle2D;
import javafx.scene.paint.Color;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Rectangle;
import javafx.scene.shape.TriangleMesh;

import static com.almasb.fxgl.dsl.FXGL.*;

public class AsteroidsGameFactory implements EntityFactory {

    @Spawns("PlayerShip")
    public Entity newPlayerShip(SpawnData data) {
        return entityBuilder(data)
                .type(AsteroidsEntityType.PLAYER_SHIP)
                .view("Ship.png")
                .collidable()
                .buildAndAttach();
    }

    @Spawns("Saucer")
    public Entity newSaucer(SpawnData data) {
        return entityBuilder(data)
                .type(AsteroidsEntityType.SAUCER)
                .viewWithBBox(new Circle(40, 40, 20.0, Color.BLUE))
                .collidable()
                .build();
    }

    @Spawns("BigAsteroid")
    public Entity newBigAsteroid(SpawnData data) {
        return entityBuilder(data)
                .type(AsteroidsEntityType.BIG_ASTEROID)
                .viewWithBBox(new Circle(40, 40, 20.0, Color.RED))
                .with(new RandomMoveComponent(new Rectangle2D(0, 0, getAppWidth(), getAppHeight()), 150))
                .collidable()
                .build();
    }
}
