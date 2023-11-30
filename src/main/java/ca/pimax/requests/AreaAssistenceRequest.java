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
public class AreaAssistenceRequest {

    @NotNull(message = "El campo es obligatorio.")
    private Integer area_id;

    @NotNull(message = "El campo es obligatorio.")
    private LocalDate dateInit;

    @NotNull(message = "El campo es obligatorio.")
    private LocalDate dateEnd;
}
