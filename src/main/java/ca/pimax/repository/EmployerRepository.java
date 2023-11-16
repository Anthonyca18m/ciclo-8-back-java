package ca.pimax.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ca.pimax.models.User;

public interface EmployerRepository extends JpaRepository<User, Long> {

    @Query(value = "CALL list_employes(:search, :limite, :area_id)", nativeQuery = true)
    List<User> findAllEmployes(@Param("search") String search, @Param("limite") Integer limite, @Param("area_id") Long area_id);

    @Query(value = "SELECT delete_employer(:user_id)", nativeQuery = true)
    int deleteEmployer(@Param("user_id") Long user_id);

}
