package ca.pimax.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import ca.pimax.models.TypeContrato;

public interface TypeContratoRepository extends JpaRepository<TypeContrato, Long> {
    
}
