package ca.pimax.auth;

import ca.pimax.models.Role;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RegisterRequest {
    
    @Valid
    private Role role;

    @NotBlank(message = "El campo es obligatorio.")
    private String name;

    @NotBlank(message = "El campo es obligatorio.")
    @Size(min = 8, max = 8, message = "El campo debe tener 8 caracteres.")
    private String document;

    @NotBlank(message = "El campo es obligatorio.")
    @Size(min = 2, max = 50, message = "El campo debe tener 6 caracteres como mínimo.")
    @Pattern(regexp = "^[a-zA-Z]+$", message = "El campo solo debe tener letras.")
    private String username;

    @NotBlank(message = "El campo es obligatorio.")
    @Size(min = 6, max = 50, message = "El campo debe tener 6 caracteres como mínimo.")
    private String password;
}
