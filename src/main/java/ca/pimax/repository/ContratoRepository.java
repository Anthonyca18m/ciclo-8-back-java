package ca.pimax.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import ca.pimax.models.Contrato;

public interface ContratoRepository  extends JpaRepository<Contrato, Long> {
    
}
