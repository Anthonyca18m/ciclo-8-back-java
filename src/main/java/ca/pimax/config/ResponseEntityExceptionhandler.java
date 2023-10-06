package ca.pimax.config;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import java.util.List;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import ca.pimax.responses.ErrorResponse;

@ControllerAdvice
public class ResponseEntityExceptionhandler extends ResponseEntityExceptionHandler {

    @Override
    protected ResponseEntity<Object> handleMethodArgumentNotValid(MethodArgumentNotValidException ex,
            HttpHeaders headers, HttpStatusCode status, WebRequest request) {

        Map<String, List<String>> errors = new HashMap<>();
        ex.getBindingResult().getFieldErrors().forEach(err -> {
            String fieldName = err.getField();
            String errorMessage = err.getDefaultMessage();
            if (errors.containsKey(fieldName)) {
                errors.get(fieldName).add(errorMessage);
            } else {
                List<String> errorList = new ArrayList<>();
                errorList.add(errorMessage);
                errors.put(fieldName, errorList);
            }
        });

        ErrorResponse errorResponse = new ErrorResponse("The given data was invalid.", errors);

        return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY).body(errorResponse);
    }
}
