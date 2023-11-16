package ca.pimax.services;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import ca.pimax.models.Asistencia;
import ca.pimax.models.User;
import ca.pimax.repository.AsistenciaRepository;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AsistenciaService {
    private final AsistenciaRepository repo;
    private final LogService log;
    private final UserService userS;

    public List<Object[]> getAll(String search, Integer limit, String type, String device)
    {
        return repo.findAll(search, limit, type, device);
    }

    public ResponseEntity<?> register(String codigo, String type_r, String user_created, HttpServletRequest rq) 
    {
        String result = repo.registerAsistenciaA(codigo, type_r, user_created);

        String[] parts = result.split("-", 2);
        String statusCode = "500";
        String message = "Error interno.";        

        if (parts.length == 2) {
            statusCode = parts[0].trim();
            message = parts[1].trim();
        }   

        return ResponseEntity.status(HttpStatus.valueOf(Integer.parseInt(statusCode))).body(message.toString());
    }

    public ResponseEntity<?> registerManual(Long userId, String typeR,String typeES, String userSession, LocalDateTime date_at, HttpServletRequest rq) {
        Asistencia asistencia = new Asistencia();
        User user = userS.findById(userId).get();
        asistencia.setUser(user);
        asistencia.setInOut(typeR);
        asistencia.setTypeR(typeES);
        asistencia.setTimeAt(date_at);
        asistencia.setMin_cu(0);
        asistencia.setUser_created(log.getUserSession());
        repo.save(asistencia);

        return ResponseEntity.ok(asistencia);
    }

    public boolean deleteById(Long id, HttpServletRequest rq) {
        Asistencia asistencia = repo.findById(id).get();
        try {
            log.insertLog(rq, "DELETE MARCACION", asistencia.getAsistenciatoString(), id.toString());
            
            repo.delete(asistencia);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
