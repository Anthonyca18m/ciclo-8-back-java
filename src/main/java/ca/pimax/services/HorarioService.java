package ca.pimax.services;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import ca.pimax.models.Horario;
import ca.pimax.repository.HorarioRepository;
import ca.pimax.requests.HorarioUpdateRequest;
import ca.pimax.requests.RegisterHorarioRequest;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class HorarioService {
    
    private final HorarioRepository horarioR;
    private final LogService logService;

    public List<Horario> getAll(String search, Integer limit)
    {
        return horarioR.findAll(search, limit);
    }

    public void register(RegisterHorarioRequest request, HttpServletRequest rq) 
    {
        Horario horario = new Horario();

        horario.setHour_in(request.getInit());
        horario.setHour_out(request.getEnd());
        horario.setTolerancia(request.getTolerancia());
        horario.setUser_created(logService.getUserSession());
        horario.setCreated_at(LocalDateTime.now());
        horarioR.save(horario);

        logService.insertLog(rq, "REG HORARIO", null, request.toString());
    }

    public ResponseEntity<?> findById(Long id)
    {        
        Optional<Horario> find = horarioR.findById(id);
        return ResponseEntity.ok(find);
    }

    public ResponseEntity<?> updateById(HorarioUpdateRequest request, Long id, HttpServletRequest rq)
    {
        Horario horario = horarioR.findById(id).get();

        logService.insertLog(rq, "UPT HORARIO", horario.toString(), request.toString());

        horario.setHour_in(request.getInit());
        horario.setHour_out(request.getEnd());
        horario.setUser_updated(logService.getUserSession());
        horario.setUpdated_at(LocalDateTime.now());
        horarioR.save(horario);

        return ResponseEntity.ok(horario);
    }

    public boolean deleteById(Long id, HttpServletRequest rq) {
        Horario horario = horarioR.findById(id).get();
        try {            
            int exits = horarioR.exitsUsers(id);
            
            if (exits == 0) {
                horarioR.delete(horario);
                logService.insertLog(rq, "DELETE HORARIO", horario.toString(), id.toString());
            }
            return (exits == 0);
        } catch (Exception e) {
            return false;
        }
    }
}
