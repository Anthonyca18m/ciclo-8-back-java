package ca.pimax.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ca.pimax.models.Area;


public interface AreaRepository extends JpaRepository<Area, Long> {
    
    @Query(value = "SELECT * FROM areas h " + 
        "WHERE (h.area LIKE %:search% OR h.id LIKE %:search%)  LIMIT :limite", nativeQuery = true)
    List<Area> findAll(@Param("search") String search, @Param("limite") Integer limite);

    @Query(value = "SELECT COUNT(*) FROM users WHERE area_id = :area_id", nativeQuery = true)
    int exitsUsers(@Param("area_id") Long area_id);
}