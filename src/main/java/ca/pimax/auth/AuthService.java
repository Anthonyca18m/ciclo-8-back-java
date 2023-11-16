package ca.pimax.auth;


import java.time.LocalDateTime;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import ca.pimax.auth.jwt.JwtService;
import ca.pimax.models.LogLogin;
import ca.pimax.models.User;
import ca.pimax.repository.LogLoginRepository;
import ca.pimax.repository.UserRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;
    private final LogLoginRepository logLoginR;

    public LoginResponse login(LoginRequest request) 
    {
        authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
        );
        
        User detail = userRepository.findByUsernameAndStatus(request.getUsername(), 1);
        
        UserDetails user = userRepository.findByUsername(request.getUsername()).orElseThrow();
        String token = jwtService.getToken(user);
        
        insertLogLogin(detail.getId());

        return LoginResponse.builder()
            .id(detail.getId())
            .username(user.getUsername())
            .role(detail.getRole().toString())
            .name(detail.getName())
            .token(token)
            .build();
    }

    public void insertLogLogin(Long user_id)
    {
        LogLogin logLogin = new LogLogin();
        logLogin.setUser_id(user_id);
        logLogin.setCreated_at(LocalDateTime.now());
        logLoginR.save(logLogin);
    }

    public String generateCode(String username)
    {
        return userRepository.getCode(username);        
    }
}
