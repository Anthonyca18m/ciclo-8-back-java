package ca.pimax.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;


import ca.pimax.models.LogMove;
import jakarta.transaction.Transactional;

public interface LogRepository extends JpaRepository<LogMove, Long> {
    
    @Query(value = "SELECT ll.id, u.username, u.name, ll.created_at FROM log_logins ll inner join users u on ll.user_id = u.id " + 
        "WHERE (u.name LIKE %:search% OR u.username LIKE %:search% OR u.code LIKE %:search%) ORDER BY ll.id DESC LIMIT :limite", nativeQuery = true)
        List<Object[]> findAllLogins(@Param("search") String search, @Param("limite") Integer limite);

    @Query(value = "SELECT * FROM log_updates " + 
        "WHERE (username LIKE %:search% OR action_name LIKE %:search% OR url_full LIKE %:search%) ORDER BY id DESC LIMIT :limite", nativeQuery = true)
        List<LogMove> getLogMoves(@Param("search") String search, @Param("limite") Integer limite);

    @Modifying
    @Transactional
    @Query(value = "TRUNCATE TABLE log_logins", nativeQuery = true)
    void clearLogins();
}
