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

import ca.pimax.models.User;
import ca.pimax.requests.EmployerUpdateRequest;
import ca.pimax.requests.RegisterEmployerRequest;
import ca.pimax.services.EmployerService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/employes")
@RequiredArgsConstructor
public class EmployerController {

    private final EmployerService employerService;

    @GetMapping
    public List<User> getAll( @RequestParam(required = false, defaultValue = "100") Integer limit, 
        @RequestParam(required = false, defaultValue = "") String search, 
        @RequestParam(required = false, defaultValue = "") Long area_id)
    {
        return employerService.getAll(search, limit, area_id);
    }

    @GetMapping(path = "/{id}")
    public ResponseEntity<?> findById(@PathVariable Long id)
    {
        return ResponseEntity.ok().body(employerService.findById(id));
    }

    @PostMapping
    public void register(@Valid @RequestBody RegisterEmployerRequest request, HttpServletRequest rq) {        
        employerService.register(request, rq);
    }

    @PostMapping(path = "/{id}")
    public ResponseEntity<?> updateById(@Valid @RequestBody EmployerUpdateRequest request, @PathVariable Long id, HttpServletRequest rq)
    {
        return employerService.updateById(request, id, rq);
    }

    @DeleteMapping(path = "/{id}")
    public boolean deleteById(@PathVariable Long id, HttpServletRequest rq)
    {
        return employerService.deleteById(id, rq);
    }
    
}
