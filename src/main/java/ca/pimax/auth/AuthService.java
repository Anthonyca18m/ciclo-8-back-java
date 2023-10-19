package ca.pimax.auth;

// import java.time.LocalDateTime;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
// import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import ca.pimax.auth.jwt.JwtService;
import ca.pimax.models.User;
import ca.pimax.repository.UserRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final JwtService jwtService;
    // private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;    

    public LoginResponse login(LoginRequest request) 
    {
        authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
        );
        
        User detail = userRepository.findByUsernameAndStatus(request.getUsername(), 1);
        
        UserDetails user = userRepository.findByUsername(request.getUsername()).orElseThrow();
        String token = jwtService.getToken(user);
        
        this.insertLogLogin(detail.getId());

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
        userRepository.insertLogLogin(user_id);
    }

    public String generateCode(String username)
    {
        return userRepository.getCode(username);        
    }
}
