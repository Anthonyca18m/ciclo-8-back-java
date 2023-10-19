package ca.pimax.controllers;

import java.util.List;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import ca.pimax.models.LogMove;
import ca.pimax.services.LogService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;



@RestController
@RequestMapping("/api/v1/log")
@RequiredArgsConstructor
public class LogController {

    private final LogService logService;
    
    @GetMapping(value = "/logins")
    public List<Object[]> getLogins(@RequestParam(required = false, defaultValue = "100") Integer limit, 
        @RequestParam(required = false, defaultValue = "") String search)
    {
        return logService.getLogLogins(limit, search);
    }

    @GetMapping(value = "/move")
    public List<LogMove> getMove(@RequestParam(required = false, defaultValue = "100") Integer limit, 
        @RequestParam(required = false, defaultValue = "") String search)
    {
        return logService.getLogMoves(search, limit);
    }

    @DeleteMapping(value = "logins")
    public void clearLogins(HttpServletRequest request)
    {
        logService.clearLogins(request);
    }
}
