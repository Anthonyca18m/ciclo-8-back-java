package ca.pimax.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import org.springframework.data.repository.query.Param;

import ca.pimax.models.User;
import jakarta.transaction.Transactional;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByUsername(String username);

    User findByUsernameAndStatus(String username, Integer status);

    @Query(value = "CALL generar_codigo(:inputParam)", nativeQuery = true)
    String getCode(@Param("inputParam") String inputParam);

    @Query(value = "SELECT * FROM users u " + 
        "WHERE (u.name LIKE %:search% OR u.username LIKE %:search% OR u.code LIKE %:search%) " + 
        " AND u.role = 'ADMIN' LIMIT :limite", nativeQuery = true)
    List<User> findAllAdmins(@Param("search") String search, @Param("limite") Integer limite);

    @Modifying
    @Transactional
    @Query(value = "INSERT INTO log_logins (user_id) VALUES (:user_id)", nativeQuery = true)
    void insertLogLogin(@Param("user_id") Long user_id);

}
