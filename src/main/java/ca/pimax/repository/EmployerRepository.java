package ca.pimax.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ca.pimax.models.User;
import jakarta.transaction.Transactional;

public interface EmployerRepository extends JpaRepository<User, Long> {

    @Query(value = "SELECT * FROM users u " + 
        "WHERE (u.name LIKE %:search% OR u.document LIKE %:search% OR u.code LIKE %:search%) " + " AND (:area_id IS NULL OR u.area_id = :area_id) " + 
        " AND u.role = 'USR' LIMIT :limite", nativeQuery = true)
    List<User> findAllEmployes(@Param("search") String search, @Param("limite") Integer limite, @Param("area_id") Long area_id);
    
    @Modifying
    @Transactional
    @Query(value = "DELETE FROM contratos where user_id = :user_id  AND (SELECT COUNT(*) FROM in_out_users_at ou WHERE ou.user_id = :user_id) = 0", nativeQuery = true)
    int deleteContrato(@Param("user_id") Long user_id);

    @Modifying
    @Transactional
    @Query(value = "DELETE FROM users WHERE id = :user_id AND role = 'USR' AND (SELECT COUNT(*) FROM in_out_users_at ou WHERE ou.user_id = :user_id) = 0", nativeQuery = true)
    void deleteEmployer(@Param("user_id") Long user_id);

}
