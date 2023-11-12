package ca.pimax.validations.DateRange;

import java.util.Date;

import org.springframework.beans.BeanWrapperImpl;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

public class DateRangeValidator implements ConstraintValidator<ValidDateRange, Object> {
    private String startDateFieldName;
    private String endDateFieldName;

    @Override
    public void initialize(ValidDateRange constraintAnnotation) {
        this.startDateFieldName = constraintAnnotation.startDateField();
        this.endDateFieldName = constraintAnnotation.endDateField();
    }

    @Override
    public boolean isValid(Object value, ConstraintValidatorContext context) {
        try {
            Object startDateValue = new BeanWrapperImpl(value).getPropertyValue(startDateFieldName);
            Object endDateValue = new BeanWrapperImpl(value).getPropertyValue(endDateFieldName);
            
            if (startDateValue == null || endDateValue == null) {
                return true;
            }
    
            if (!(startDateValue instanceof Date) || !(endDateValue instanceof Date)) {
                throw new IllegalArgumentException("The fields must be of type java.util.Date");
            }
    
            Date startDate = (Date) startDateValue;
            Date endDate = (Date) endDateValue;
            return startDate.before(endDate);
        } catch (Exception e) {
            System.out.println(e.getStackTrace().toString());            
            return false;
        }
    }
}
