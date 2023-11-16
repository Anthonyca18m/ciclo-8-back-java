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

import ca.pimax.requests.AsistenciaFormRequest;
import ca.pimax.requests.AsistenciaModuleRequest;
import ca.pimax.services.AsistenciaService;
import ca.pimax.services.LogService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/asistencia")
@RequiredArgsConstructor
public class AsistenciaController {

    private final AsistenciaService service;
    private final LogService log;
    
    @GetMapping
    public List<Object[]> getAll( @RequestParam(required = false, defaultValue = "100") Integer limit, 
        @RequestParam(required = false, defaultValue = "") String search,
        @RequestParam(required = false, defaultValue = "") String type,
        @RequestParam(required = false, defaultValue = "") String device)
    {
        return service.getAll(search, limit, type, device);
    }

    @PostMapping(value = "/form")
    public ResponseEntity<?> register(@Valid  @RequestBody  AsistenciaFormRequest request, HttpServletRequest rq)
    {
        return service.register(request.getCodigo(), "A", null, rq);
    }

    @PostMapping(value = "/module")
    public ResponseEntity<?> registerManual(@Valid  @RequestBody  AsistenciaModuleRequest request, HttpServletRequest rq)
    {        
        return service.registerManual(request.getUserId(), "M", request.getTypeR(), log.getUserSession(), request.getDate(), rq);        
    }

    @DeleteMapping(path = "/{id}")
    public boolean deleteById(@PathVariable Long id, HttpServletRequest rq)
    {
        return service.deleteById(id, rq);
    }
}
