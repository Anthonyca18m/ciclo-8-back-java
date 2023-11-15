package ca.pimax.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ca.pimax.models.Asistencia;

public interface AsistenciaRepository extends JpaRepository<Asistencia, Long> {
    
    @Query(value = "SELECT ou.id as aId, u.name, DATE_FORMAT(ou.time_at, '%Y-%d-%c %H:%i:%s %p') as time_at, " + 
        " IF(ou.in_out = 'E', 'ENTRADA', 'SALIDA'), IF(ou.type_r = 'A', 'AUTOMATICO', 'MANUAL'), ou.user_created " + 
        " FROM in_out_users_at ou INNER JOIN users u ON ou.user_id = u.id " +
        "WHERE (u.name LIKE %:search% OR u.username LIKE %:search% OR u.code LIKE %:search%) " + 
        " AND (:type = '' OR ou.in_out = :type) " + " AND (:device = '' OR ou.type_r = :device) " +
        " AND u.role = 'USR' ORDER BY ou.id DESC LIMIT :limite", nativeQuery = true)
    List<Object[]> findAll(@Param("search") String search
        , @Param("limite") Integer limite , @Param("type") String type , @Param("device") String device);

    @Query(value = "SELECT registrarAsistencia(:codigo, :type_r, :user_created)", nativeQuery = true)
    String registerAsistencia(@Param("codigo") Integer codigo, @Param("type_r") String type_r, @Param("user_created") String user_created);
}
