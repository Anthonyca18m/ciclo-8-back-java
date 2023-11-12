package ca.pimax.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import ca.pimax.models.Area;

public interface AreaRepository extends JpaRepository<Area, Long> {
    
}