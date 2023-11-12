package ca.pimax.requests;

import java.time.LocalTime;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RegisterHorarioRequest { 
    
    @NotNull(message = "El campo es obligatorio.")
    private LocalTime init;

    @NotNull(message = "El campo es obligatorio.")
    private LocalTime end;

    @NotNull(message = "El campo es obligatorio.")
    private Integer tolerancia;
}
