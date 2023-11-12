package ca.pimax.requests;

import java.sql.Date;

import ca.pimax.models.Role;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
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
public class RegisterEmployerRequest {
    @Pattern(regexp = "^[a-zA-Z ]+$", message = "El campo solo debe tener letras.")
    @NotBlank(message = "El campo es obligatorio.")
    private String name;

    @NotBlank(message = "El campo es obligatorio.")
    @Size(min = 8, max = 8, message = "El campo debe tener 8 digitos.")
    @Pattern(regexp = "^[0-9]+$", message = "El campo solo debe tener digitos.")
    private String document;

    @NotNull(message = "El campo es obligatorio.")
    private Long area_id;

    @NotNull(message = "El campo es obligatorio.")
    private Long jornada_id;

    @NotNull(message = "El campo es obligatorio.")
    private Long horario_id;

    @NotNull(message = "El campo es obligatorio.")
    private Date dateInit;

    @NotNull(message = "El campo es obligatorio.")        
    private Date dateEnd;

    @NotNull(message = "El campo es obligatorio.")
    private Double c_salary;

    @Valid
    private Role role;
}
