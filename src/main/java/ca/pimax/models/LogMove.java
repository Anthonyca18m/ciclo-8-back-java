package ca.pimax.models;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
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
@Table(name = "log_updates")
public class LogMove {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String username;

    @Column(nullable = false)
    private String action_name;

    @Column(nullable = true)
    private String orig_data;

    @Column(nullable = true)
    private String rep_data;

    @Column(nullable = false)
    private String url_full;

    @Column(nullable = true)
    private String ip_user;

    @Column(nullable = false)
    private LocalDateTime created_at;
    
}
