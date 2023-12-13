package ca.pimax.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ca.pimax.models.Asistencia;


public interface AsistenciaRepository extends JpaRepository<Asistencia, Long> {
    
    @Query(value = "CALL list_asistencia(:search, :type, :device, :limite)", nativeQuery = true)
    List<Object[]> findAll(@Param("search") String search
        , @Param("limite") Integer limite , @Param("type") String type , @Param("device") String device);

    @Query(value = "SELECT registrarAsistencia(:codigo, :type_r, :user_created)", nativeQuery = true)
    String registerAsistenciaA(@Param("codigo") String codigo, @Param("type_r") String type_r, @Param("user_created") String user_created);

    @Query(value = "SELECT getMinTardanzaRM(:user_id, :time_at)", nativeQuery = true)
    Integer getMinTardanzaRM(@Param("user_id") Long user_id, @Param("time_at") LocalDateTime time_at);

}
