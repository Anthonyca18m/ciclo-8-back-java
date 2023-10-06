package ca.pimax.auth;

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
public class LoginRequest {

    @NotBlank(message = "El campo es obligatorio.")
    @Size(min = 2, max = 50, message = "El campo debe tener 6 caracteres como mínimo.")
    @Pattern(regexp = "^[a-zA-Z]+$", message = "El campo solo debe tener letras.")
    private String username;

    @NotBlank(message = "El campo es obligatorio.")
    @Size(min = 6, max = 50, message = "El campo debe tener 6 caracteres como mínimo.")
    private String password;
}
