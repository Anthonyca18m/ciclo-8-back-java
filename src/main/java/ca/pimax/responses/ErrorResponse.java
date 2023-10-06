package ca.pimax.responses;

import java.util.Map;
import java.util.List;

import lombok.Data;

@Data
public class ErrorResponse {
    private String message;
    private Map<String, List<String>> errors;

    public ErrorResponse(String message, Map<String, List<String>> errors) {
        this.message = message;
        this.errors = errors;
    }
}
