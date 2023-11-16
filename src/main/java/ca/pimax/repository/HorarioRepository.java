package ca.pimax.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ca.pimax.models.Horario;

public interface HorarioRepository extends JpaRepository<Horario, Long> {  
    
    @Query(value = "CALL list_horarios(:search, :limite)", nativeQuery = true)
    List<Horario> findAll(@Param("search") String search, @Param("limite") Integer limite);

    @Query(value = "CALL exits_horario_contratos(:horario_id)", nativeQuery = true)
    int exitsUsers(@Param("horario_id") Long horario_id);
}
