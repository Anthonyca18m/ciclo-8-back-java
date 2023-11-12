package ca.pimax.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ca.pimax.models.Horario;

public interface HorarioRepository extends JpaRepository<Horario, Long> {  
    
    @Query(value = "SELECT * FROM horarios h " + 
        "WHERE (h.hour_in LIKE %:search% OR h.hour_out LIKE %:search% OR h.id LIKE %:search%)  LIMIT :limite", nativeQuery = true)
    List<Horario> findAll(@Param("search") String search, @Param("limite") Integer limite);

    @Query(value = "SELECT COUNT(*) FROM contratos WHERE horario_id = :horario_id", nativeQuery = true)
    int exitsUsers(@Param("horario_id") Long horario_id);
}
