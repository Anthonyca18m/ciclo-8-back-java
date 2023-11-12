package ca.pimax.requests;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RegisterAreaRequest {
    
    @NotBlank(message = "El campo es obligatorio.")
    private String name;
}
