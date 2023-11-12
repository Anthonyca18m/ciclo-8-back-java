package ca.pimax.controllers;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ca.pimax.services.SelectService;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/select")
@RequiredArgsConstructor
public class SelectController {
    
    private final SelectService selectService;

    @GetMapping(value = "/areas")
    public List<Map<String, Object>> getSelectArea()
    {
        return selectService.getSelectArea();
    }

    @GetMapping(value = "/jornadas")
    public List<Map<String, Object>> getSelectJornada()
    {
        return selectService.getSelectJornada();
    }

    @GetMapping(value = "/horarios")
    public List<Map<String, Object>> getSelectHorario()
    {
        return selectService.getSelectHorario();
    }
}
