package ca.pimax.controllers;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ca.pimax.services.SelectService;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/select")
@RequiredArgsConstructor
public class SelectController {
    
    private final SelectService service;

    @GetMapping(value = "/{option}")
    public List<Map<String, Object>> getSelect(@PathVariable String option)
    {
        return service.getSelect(option);
    }


}
