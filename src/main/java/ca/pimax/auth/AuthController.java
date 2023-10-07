package ca.pimax.auth;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {
    
    private final AuthService authService;

    @PostMapping(value = "login")
    public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.login(request));        
    }

    @PostMapping(value="logout")
    public void logout(@RequestBody LogoutRequest request) {
    }
    

    @PostMapping(value = "register")
    public void register(@RequestBody RegisterRequest request) {
        // return ResponseEntity.ok(authService.register(request));
        authService.register(request);
    }

}
