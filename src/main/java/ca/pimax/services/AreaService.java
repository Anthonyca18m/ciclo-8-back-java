package ca.pimax.services;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import ca.pimax.models.Area;
import ca.pimax.repository.AreaRepository;
import ca.pimax.requests.AreaUpdateRequest;
import ca.pimax.requests.RegisterAreaRequest;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AreaService {
    
    private final AreaRepository areaR;
    private final LogService logService;

    public List<Area> getAll(String search, Integer limit)
    {
        return areaR.findAll(search, limit);
    }

    public void register(RegisterAreaRequest request, HttpServletRequest rq) 
    {
        Area area = new Area();

        area.setArea(request.getName());
        area.setUser_created(logService.getUserSession());
        area.setCreated_at(LocalDateTime.now());
        areaR.save(area);

        logService.insertLog(rq, "REG AREA", null, request.toString());
    }

    public ResponseEntity<?> findById(Long id)
    {        
        Optional<Area> find = areaR.findById(id);
        return ResponseEntity.ok(find);
    }

    public ResponseEntity<?> updateById(AreaUpdateRequest request, Long id, HttpServletRequest rq)
    {
        Area area = areaR.findById(id).get();

        logService.insertLog(rq, "UPT AREA", area.toString(), request.toString());

        area.setArea(request.getName());        
        area.setUser_updated(logService.getUserSession());
        area.setUpdated_at(LocalDateTime.now());
        areaR.save(area);

        return ResponseEntity.ok(area);
    }

    public boolean deleteById(Long id, HttpServletRequest rq) {
        Area area = areaR.findById(id).get();
        try {            
            int exits = areaR.exitsUsers(id);
            
            if (exits == 0) {
                areaR.delete(area);
                logService.insertLog(rq, "DELETE AREA", area.toString(), id.toString());
            }
            return (exits == 0);
        } catch (Exception e) {
            return false;
        }
    }
}
