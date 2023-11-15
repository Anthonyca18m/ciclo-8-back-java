package ca.pimax.requests;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AsistenciaFormRequest {
    
    @NotNull(message = "El campo es obligatorio.")
    private Integer codigo;
}
