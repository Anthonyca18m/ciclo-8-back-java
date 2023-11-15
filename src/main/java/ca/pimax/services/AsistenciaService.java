package ca.pimax.services;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import ca.pimax.repository.AsistenciaRepository;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AsistenciaService {
    private final AsistenciaRepository repo;
    private final LogService logService;

    public List<Object[]> getAll(String search, Integer limit, String type, String device)
    {
        return repo.findAll(search, limit, type, device);
    }

    public ResponseEntity<?> register(Integer codigo, String type_r, String user_created, HttpServletRequest rq) 
    {
        String result = repo.registerAsistencia(codigo, type_r, user_created);

        String[] parts = result.split("-", 2);
        String statusCode = "500";
        String message = "Error interno.";        

        if (parts.length == 2) {
            statusCode = parts[0].trim();
            message = parts[1].trim();
        }   

        return ResponseEntity.status(HttpStatus.valueOf(Integer.parseInt(statusCode))).body(message.toString());
    }
}
