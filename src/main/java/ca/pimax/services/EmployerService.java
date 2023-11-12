package ca.pimax.services;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import ca.pimax.models.Area;
import ca.pimax.models.Contrato;
import ca.pimax.models.TypeContrato;
import ca.pimax.models.User;
import ca.pimax.repository.AreaRepository;
import ca.pimax.repository.ContratoRepository;
import ca.pimax.repository.EmployerRepository;
import ca.pimax.repository.TypeContratoRepository;
import ca.pimax.repository.UserRepository;
import ca.pimax.requests.EmployerUpdateRequest;
import ca.pimax.requests.RegisterEmployerRequest;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class EmployerService {
    
    private final LogService logService;
    private final UserRepository userR;
    private final EmployerRepository employerRepository;
    private final ContratoRepository contratoRepository;
    private final PasswordEncoder passwordEncoder;
    private final AreaRepository areaR;
    private final TypeContratoRepository typeContratoR;
    
    public List<User> getAll(String search, Integer limit, Long area_id)
    {
        return employerRepository.findAllEmployes(search, limit, area_id);
    }

    public ResponseEntity<?> findById(Long id)
    {        
        Optional<User> user = employerRepository.findById(id);

        return ResponseEntity.ok(user);
    }

    public ResponseEntity<?> updateById(EmployerUpdateRequest request, Long id, HttpServletRequest rq)
    {
        User user = userR.findById(id).get();
        Area area = areaR.findById(request.getArea_id()).get();
        TypeContrato type = typeContratoR.findById(request.getJornada_id()).get();
        logService.insertLog(rq, "UPDATE USR", user.getName(), request.toString());

        user.setName(request.getName());
        user.setArea(area);
        user.setDocument(request.getDocument());        
        user.setStatus(request.getStatus());
        user.setUpdated_at(LocalDateTime.now());

        Contrato contrato = user.getContrato();
        contrato.setType(type);
        contrato.setHorario_id(request.getHorario_id());
        contrato.setDate_init(request.getDateInit());
        contrato.setDate_end(request.getDateEnd());
        contrato.setSalario(request.getC_salary());
        contrato.setUpdated_at(LocalDateTime.now());
        contrato.setUser_updated(logService.getUserSession());

        java.sql.Date dateEndSql = request.getDateEnd();
        LocalDate dateEndLocalDate = dateEndSql.toLocalDate();
        LocalDate currentDate = LocalDate.now();
        contrato.setStatus((currentDate.isAfter(dateEndLocalDate)) ? "0":"1");


        userR.save(user);
        return ResponseEntity.ok().body(user);
    }

    public void register(RegisterEmployerRequest request, HttpServletRequest rq) 
    {
        Area area = areaR.findById(request.getArea_id()).get();

        User user = User.builder()
                .username(request.getDocument().toString())
                .password(passwordEncoder.encode(LocalDateTime.now().toString()))
                .area(area)
                .code(generateCode(request.getName()))
                .name(request.getName().toUpperCase())
                .document(request.getDocument())
                .created_at(LocalDateTime.now())
                .role(request.getRole())
                .status(1)
        .build();

        employerRepository.save(user);

        TypeContrato type = typeContratoR.findById(request.getJornada_id()).get();

        Contrato contrato = Contrato.builder()
            .user(user)
            .type(type)
            .horario_id(request.getHorario_id())
            .date_init(request.getDateInit())
            .date_end(request.getDateEnd())
            .salario(request.getC_salary())
            .status("1")
            .created_at(LocalDateTime.now())
            .user_created(logService.getUserSession())        
        .build();

        contratoRepository.save(contrato);

        logService.insertLog(rq, "REG USR", null, request.toString());
    }

    public String generateCode(String username)
    {
        return userR.getCode(username);
    }

    public boolean deleteById(Long id, HttpServletRequest rq) {
        User user = userR.findById(id).get();
        try {
            logService.insertLog(rq, "DELETE USR", user.getName(), id.toString());
            
            int exits = employerRepository.deleteContrato(id);
            employerRepository.deleteEmployer(id);
            return (exits == 1);
        } catch (Exception e) {
            return false;
        }
    }
}
