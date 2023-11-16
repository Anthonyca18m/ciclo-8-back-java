package ca.pimax.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;


import ca.pimax.models.LogMove;
import jakarta.transaction.Transactional;

public interface LogRepository extends JpaRepository<LogMove, Long> {
    
    @Query(value = "CALL list_log_logins(:search, :limite)", nativeQuery = true)
    List<Object[]> findAllLogins(@Param("search") String search, @Param("limite") Integer limite);

    @Query(value = "CALL list_log_move(:search, :limite)", nativeQuery = true)
    List<LogMove> getLogMoves(@Param("search") String search, @Param("limite") Integer limite);

    @Modifying
    @Transactional
    @Query(value = "CALL clear_logins()", nativeQuery = true)
    void clearLogins();
}
