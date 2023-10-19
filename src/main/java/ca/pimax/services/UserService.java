package ca.pimax.services;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import ca.pimax.auth.RegisterRequest;
import ca.pimax.models.User;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import ca.pimax.repository.UserRepository;
import ca.pimax.requests.UserUpdateRequest;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {

    private final LogService logService;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;  

    public Optional<User> findById(Long id)
    {
        return userRepository.findById(id);
    }

    public User updateById(UserUpdateRequest request, Long id, HttpServletRequest rq)
    {
        User user = userRepository.findById(id).get();

        logService.insertLog(rq, "UPDATE ADM", user.getUsername() +" | "+ user.getName(), request.getUsername() +" | "+ request.getName());

        user.setName(request.getName());
        user.setDocument(request.getDocument());
        user.setUsername(request.getUsername());
        user.setStatus(request.getStatus());
        if (!request.getPassword().isEmpty()) {
            user.setPassword(passwordEncoder.encode(request.getPassword()));
        }
        user.setUpdated_at(LocalDateTime.now());
        userRepository.save(user);

        return user;
    }

    public List<User> getAdmins(Integer limit, String search)
    {
        return userRepository.findAllAdmins(search, limit);
    }

    public void register(RegisterRequest request, HttpServletRequest rq) 
    {
        User user = User.builder()
                .username(request.getUsername().toLowerCase())
                .password(passwordEncoder.encode(request.getPassword()))
                .code(generateCode(request.getName()))
                .name(request.getName().toUpperCase())
                .document(request.getDocument())
                .created_at(LocalDateTime.now())
                .role(request.getRole())
                .status(1)
                .build();

        userRepository.save(user);

        logService.insertLog(rq, "REG ADM", null, request.getUsername() +" | "+ request.getName());
    }

    public String generateCode(String username)
    {
        return userRepository.getCode(username);        
    }

    public boolean deleteById(Long id, HttpServletRequest rq) {
        User user = userRepository.findById(id).get();
        try {
            logService.insertLog(rq, "DELETE USER", user.getUsername() +" | "+ user.getName(), id.toString());
            
            userRepository.delete(user);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
}
