package ca.pimax.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import org.springframework.data.repository.query.Param;

import ca.pimax.models.User;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByUsername(String username);

    User findByUsernameAndStatus(String username, Integer status);

    @Query(value = "CALL generar_codigo(:inputParam)", nativeQuery = true)
    String getCode(@Param("inputParam") String inputParam);

    @Query(value = "CALL list_users(:search, :limite)", nativeQuery = true)
    List<User> findAllAdmins(@Param("search") String search, @Param("limite") Integer limite);

}
