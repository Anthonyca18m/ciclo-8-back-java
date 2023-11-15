package ca.pimax.models;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "in_out_users_at")
public class Asistencia {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(nullable = true, insertable = true, name = "user_id", referencedColumnName = "id")
    private User user;

    @Column(name = "in_out", nullable = false, columnDefinition = "CHAR") // E: ENTRADA, S: SALIDA
    private char inOut;

    @Column(name = "type_r", nullable = false, columnDefinition = "CHAR") // A: AUTOMATICO, M: MANUAL
    private char typeR;

    @Column(nullable = true)
    private int min_cu;

    @Column(name = "time_at", nullable = false, columnDefinition = "TIMESTAMP")
    private LocalDateTime timeAt;

    private String user_created;
}
