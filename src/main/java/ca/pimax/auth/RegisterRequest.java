package ca.pimax.auth;

import ca.pimax.models.Role;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RegisterRequest {
    private Role role;
    private String name;
    private String document;
    private String username;
    private String password;
}
