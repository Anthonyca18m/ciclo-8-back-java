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

import ca.pimax.models.TypeContrato;
import ca.pimax.requests.RegisterTypeContratoRequest;
import ca.pimax.requests.TypeContratoUpdateRequest;
import ca.pimax.services.TypeContratoService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/typecontratos")
@RequiredArgsConstructor
public class TypeContratoController {
    private final TypeContratoService tcS;
    
    @GetMapping
    public List<TypeContrato> getAll( @RequestParam(required = false, defaultValue = "100") Integer limit, 
        @RequestParam(required = false, defaultValue = "") String search)
    {
        return tcS.getAll(search, limit);
    }

    @PostMapping
    public void register(@Valid @RequestBody RegisterTypeContratoRequest request, HttpServletRequest rq) {        
        tcS.register(request, rq);
    }

    @GetMapping(path = "/{id}")
    public ResponseEntity<?> findById(@PathVariable Long id)
    {
        return ResponseEntity.ok(tcS.findById(id));
    }

    @PostMapping(path = "/{id}")
    public ResponseEntity<?> updateById(@Valid @RequestBody TypeContratoUpdateRequest request, @PathVariable Long id, HttpServletRequest rq)
    {
        return tcS.updateById(request, id, rq);
    }

    @DeleteMapping(path = "/{id}")
    public boolean deleteById(@PathVariable Long id, HttpServletRequest rq)
    {
        return tcS.deleteById(id, rq);
    }
}
