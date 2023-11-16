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
    
    public List<Map<String, Object>> getSelect(String option) {
        return selectRepository.select(option).stream().map(rs -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", rs[0]);
            map.put("name", rs[1]);
            return map;
        }).collect(Collectors.toList());
    }
}
