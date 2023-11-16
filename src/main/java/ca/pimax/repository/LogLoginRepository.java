package ca.pimax.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import ca.pimax.models.LogLogin;

public interface LogLoginRepository extends JpaRepository<LogLogin, Long> {
    
}
