package ca.pimax.services;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import ca.pimax.models.LogMove;
import ca.pimax.repository.LogRepository;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class LogService {
    
    private final LogRepository logRepository;

    public List<Object[]> getLogLogins(Integer limit, String search)
    {
        return logRepository.findAllLogins(search, limit);
    }

    public void clearLogins(HttpServletRequest request) 
    {
        this.insertLog(request, "CLEAR LOG LOGIN", null, null);
        logRepository.clearLogins();
    }

    public void insertLog(HttpServletRequest request, String title, String orig_data, String rep_data)
    {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        LogMove logMove = new LogMove();
        logMove.setUsername(username);
        logMove.setAction_name(title);
        logMove.setOrig_data(orig_data);
        logMove.setRep_data(rep_data);
        logMove.setUrl_full(request.getRequestURL().toString());
        logMove.setIp_user(request.getRemoteAddr().toString());
        logMove.setCreated_at(LocalDateTime.now());
        logRepository.save(logMove);
    }

    public List<LogMove> getLogMoves(String search, Integer limit) {
        return logRepository.getLogMoves(search, limit);
    }

    public String getUserSession()
    {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        return username;
    }
}
