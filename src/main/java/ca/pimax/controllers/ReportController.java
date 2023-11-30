package ca.pimax.controllers;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ca.pimax.requests.AreaAssistenceRequest;
import ca.pimax.requests.EmployerAssistenceRequest;
import ca.pimax.services.ReportService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/reports")
@RequiredArgsConstructor
public class ReportController {

    private final ReportService reportS;
    
    @GetMapping(value = "widgets")
    public List<?> getWidgets() {
        return reportS.getWidgets();
    }

    @GetMapping(value = "gpc-tardanzas")
    public List<?> graphicTardanzas() {
        return reportS.graphicTardanzas();
    }

    @GetMapping(value = "employer/asistencia")
    public List<?> employerAsistence(@Valid EmployerAssistenceRequest request) 
    {
        return reportS.employerAsistence(request.getDateInit(), request.getDateEnd(), request.getUserId());
    }

    @GetMapping(value = "area/asistencia")
    public List<?> areaAsistence(@Valid AreaAssistenceRequest request) 
    {
        return reportS.areaAsistence(request.getDateInit(), request.getDateEnd(), request.getArea_id());
    }

    @GetMapping(value = "contratos")
    public List<?> reportContratos() {
        return reportS.reportContratos();
    }
    
}
