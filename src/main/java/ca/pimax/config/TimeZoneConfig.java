package ca.pimax.config;

import java.util.TimeZone;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class TimeZoneConfig {
    
    @Bean
    public TimeZone timeZone() 
    {
        TimeZone defaultTimeZone = TimeZone.getTimeZone("America/Lima");
        TimeZone.setDefault(defaultTimeZone);
        return defaultTimeZone;
    }
}
