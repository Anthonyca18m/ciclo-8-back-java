package ca.pimax.controllers;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import ca.pimax.models.Area;
import ca.pimax.requests.AreaUpdateRequest;
import ca.pimax.requests.RegisterAreaRequest;
import ca.pimax.services.AreaService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/areas")
@RequiredArgsConstructor
public class AreaController {
    private final AreaService areaS;
    
    @GetMapping
    public List<Area> getAll( @RequestParam(required = false, defaultValue = "100") Integer limit, 
        @RequestParam(required = false, defaultValue = "") String search)
    {
        return areaS.getAll(search, limit);
    }

    @PostMapping
    public void register(@Valid @RequestBody RegisterAreaRequest request, HttpServletRequest rq) {        
        areaS.register(request, rq);
    }

    @GetMapping(path = "/{id}")
    public ResponseEntity<?> findById(@PathVariable Long id)
    {
        return ResponseEntity.ok(areaS.findById(id));
    }

    @PostMapping(path = "/{id}")
    public ResponseEntity<?> updateById(@Valid @RequestBody AreaUpdateRequest request, @PathVariable Long id, HttpServletRequest rq)
    {
        return areaS.updateById(request, id, rq);
    }

    @DeleteMapping(path = "/{id}")
    public boolean deleteById(@PathVariable Long id, HttpServletRequest rq)
    {
        return areaS.deleteById(id, rq);
    }
}
