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

import ca.pimax.models.Horario;
import ca.pimax.requests.HorarioUpdateRequest;
import ca.pimax.requests.RegisterHorarioRequest;
import ca.pimax.services.HorarioService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/horarios")
@RequiredArgsConstructor
public class HorarioController {

    private final HorarioService horarioS;
    
    @GetMapping
    public List<Horario> getAll( @RequestParam(required = false, defaultValue = "100") Integer limit, 
        @RequestParam(required = false, defaultValue = "") String search)
    {
        return horarioS.getAll(search, limit);
    }

    @PostMapping
    public void register(@Valid @RequestBody RegisterHorarioRequest request, HttpServletRequest rq) {        
        horarioS.register(request, rq);
    }

    @GetMapping(path = "/{id}")
    public ResponseEntity<?> findById(@PathVariable Long id)
    {
        return ResponseEntity.ok().body(horarioS.findById(id));
    }

    @PostMapping(path = "/{id}")
    public ResponseEntity<?> updateById(@Valid @RequestBody HorarioUpdateRequest request, @PathVariable Long id, HttpServletRequest rq)
    {
        return horarioS.updateById(request, id, rq);
    }

    @DeleteMapping(path = "/{id}")
    public boolean deleteById(@PathVariable Long id, HttpServletRequest rq)
    {
        return horarioS.deleteById(id, rq);
    }
}
