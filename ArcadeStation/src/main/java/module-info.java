module com.example.arcadestation {
    requires javafx.controls;
    requires javafx.fxml;

    requires com.almasb.fxgl.all;

    opens com.example.arcadestation to javafx.fxml;
    exports com.example.arcadestation;
}