package ca.pimax.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ca.pimax.models.TypeContrato;

public interface TypeContratoRepository extends JpaRepository<TypeContrato, Long> {

    @Query(value = "CALL list_type_contratos(:search, :limite)", nativeQuery = true)
    List<TypeContrato> findAll(@Param("search") String search, @Param("limite") Integer limite);

    @Query(value = "CALL exits_type_contratos(:type_contrato_id)", nativeQuery = true)
    int exitsUsers(@Param("type_contrato_id") Long type_contrato_id);
}
