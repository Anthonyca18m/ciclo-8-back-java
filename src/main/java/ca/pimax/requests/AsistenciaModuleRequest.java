package ca.pimax.requests;

import java.time.LocalDateTime;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AsistenciaModuleRequest {
    @NotNull(message = "El campo es obligatorio.")
    private Long userId;

    @NotNull(message = "El campo es obligatorio.")
    private String typeR;

    @NotNull(message = "El campo es obligatorio.")
    private LocalDateTime date;
}
