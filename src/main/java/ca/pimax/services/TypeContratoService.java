package ca.pimax.services;

import java.util.List;
import java.util.Optional;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import ca.pimax.models.TypeContrato;
import ca.pimax.repository.TypeContratoRepository;
import ca.pimax.requests.RegisterTypeContratoRequest;
import ca.pimax.requests.TypeContratoUpdateRequest;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TypeContratoService {
    private final TypeContratoRepository tcR;
    private final LogService logService;

    public List<TypeContrato> getAll(String search, Integer limit)
    {
        return tcR.findAll(search, limit);
    }

    public void register(RegisterTypeContratoRequest request, HttpServletRequest rq) 
    {
        TypeContrato tc = new TypeContrato();

        tc.setName(request.getName());
        tcR.save(tc);

        logService.insertLog(rq, "REG TIPO CONTRATO", null, request.toString());
    }

    public ResponseEntity<?> findById(Long id)
    {        
        Optional<TypeContrato> find = tcR.findById(id);
        return ResponseEntity.ok(find);
    }

    public ResponseEntity<?> updateById(TypeContratoUpdateRequest request, Long id, HttpServletRequest rq)
    {
        TypeContrato tc = tcR.findById(id).get();

        logService.insertLog(rq, "UPT TIPO CONTRATO", tc.toString(), request.toString());

        tc.setName(request.getName());
        tcR.save(tc);

        return ResponseEntity.ok(tc);
    }

    public boolean deleteById(Long id, HttpServletRequest rq) {
        TypeContrato tc = tcR.findById(id).get();
        try {            
            int exits = tcR.exitsUsers(id);
            
            if (exits == 0) {
                tcR.delete(tc);
                logService.insertLog(rq, "DELETE TIPO CONTRATO", tc.toString(), id.toString());
            }
            return (exits == 0);
        } catch (Exception e) {
            return false;
        }
    }
}
