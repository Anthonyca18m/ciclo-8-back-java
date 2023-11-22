package ca.pimax.repository;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ca.pimax.models.Area;

public interface ReportRepository extends JpaRepository<Area, Long>  {


    @Query(value = "CALL list_widgets()", nativeQuery = true)
    List<?> getWidgets();

    @Query(value = "CALL graphic_tardanzas()", nativeQuery = true)
    List<Object[]> graphicTardanzas(); 
    
    @Query(value = "CALL get_all_dates_in_range(:startDate, :endDate, :user_id)", nativeQuery = true)
    List<Object[]> graphicEmployerAssistence(@Param("startDate") LocalDate startDate
        , @Param("endDate") LocalDate endDate, @Param("user_id") Integer user_id); 
}
