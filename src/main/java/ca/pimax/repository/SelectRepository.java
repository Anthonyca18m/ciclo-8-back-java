package ca.pimax.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import ca.pimax.models.LogMove;

public interface SelectRepository extends JpaRepository<LogMove, Long> {
    
    @Query(value = "SELECT id, area AS name FROM areas ORDER BY area ASC", nativeQuery = true)
    List<Object[]> areas();

    @Query(value = "SELECT id, name FROM types_contratos ORDER BY name ASC", nativeQuery = true)
    List<Object[]> jornadas();

    @Query(value = "SELECT id, CONCAT('De ', hour_in, ' a ', hour_out, ' T: ', tolerancia) AS name FROM horarios ORDER BY id ASC", nativeQuery = true)
    List<Object[]> horarios();

}
