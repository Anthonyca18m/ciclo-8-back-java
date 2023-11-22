package ca.pimax.services;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import ca.pimax.repository.ReportRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReportService {
    
    private final ReportRepository reportR;


    public List<?> getWidgets()
    {
        return reportR.getWidgets();
    }

    public List<Map<String, Object>> graphicTardanzas()
    {
        return reportR.graphicTardanzas().stream().map(rs -> {
            Map<String, Object> map = new HashMap<>();
            map.put("TARDANZA", rs[0]);
            map.put("ASISTENCIA", rs[1]);
            map.put("TOTAL", rs[2]);
            map.put("MES", rs[3]);
            return map;
        }).collect(Collectors.toList());
    }

    public List<Map<String, Object>> employerAsistence(LocalDate startDate, LocalDate endDate, Integer user_id)
    {
        return reportR.graphicEmployerAssistence(startDate, endDate, user_id).stream().map(rs -> {
            Map<String, Object> map = new HashMap<>();
            map.put("DAY", rs[0]);
            map.put("DAYNAME", rs[1]);
            map.put("USER_ID", rs[2]);
            map.put("ENTRADA", rs[3]);
            map.put("SALIDA", rs[4]);
            map.put("TARDANZA", rs[5]);
            map.put("USERNAME", rs[6]);
            return map;
        }).collect(Collectors.toList());        
    }

}
