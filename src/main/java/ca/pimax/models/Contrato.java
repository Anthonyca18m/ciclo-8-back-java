package ca.pimax.models;

import java.sql.Date;

import com.fasterxml.jackson.annotation.JsonBackReference;

import java.time.LocalDateTime;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
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
@Table(name = "contratos")
public class Contrato {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonBackReference
    @OneToOne(cascade = CascadeType.ALL, optional = false)
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(nullable = true, insertable = true, name = "area_id", referencedColumnName = "id")
    private Area area;

    @ManyToOne
    @JoinColumn(nullable = true, insertable = true, name = "type_contrato_id", referencedColumnName = "id")
    private TypeContrato type;

    @Column(nullable = false)
    private Long horario_id;

    @Column(nullable = false)
    private Date date_init;

    @Column(nullable = false)
    private Date date_end;

    @Column(nullable = false)
    private Double salario;

    @Column(nullable = false)
    private String status;

    private LocalDateTime created_at;
    private LocalDateTime updated_at;
    private String user_created;
    private String user_updated;
}
