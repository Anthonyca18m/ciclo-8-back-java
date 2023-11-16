package ca.pimax.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ca.pimax.models.LogMove;

public interface SelectRepository extends JpaRepository<LogMove, Long> {

    @Query(value = "CALL select_uni(:option)", nativeQuery = true)
    List<Object[]> select(@Param("option") String select);

}
