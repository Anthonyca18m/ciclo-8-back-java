package ca.pimax.services;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import ca.pimax.repository.SelectRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SelectService {
    
    private final SelectRepository selectRepository;

    public List<Map<String, Object>> getSelectArea() {
        return selectRepository.areas().stream().map(rs -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", rs[0]);
            map.put("name", rs[1]);
            return map;
        }).collect(Collectors.toList());
    }

    public List<Map<String, Object>> getSelectJornada() {
        return selectRepository.jornadas().stream().map(rs -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", rs[0]);
            map.put("name", rs[1]);
            return map;
        }).collect(Collectors.toList());
    }

    public List<Map<String, Object>> getSelectHorario() {
        return selectRepository.horarios().stream().map(rs -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", rs[0]);
            map.put("name", rs[1]);
            return map;
        }).collect(Collectors.toList());
    }
}
