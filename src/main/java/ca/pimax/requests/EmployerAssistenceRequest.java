package ca.pimax.requests;

import java.time.LocalDate;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EmployerAssistenceRequest {
    
    @NotNull(message = "El campo es obligatorio.")
    private Integer userId;

    @NotNull(message = "El campo es obligatorio.")
    private LocalDate dateInit;

    @NotNull(message = "El campo es obligatorio.")
    private LocalDate dateEnd;

}
