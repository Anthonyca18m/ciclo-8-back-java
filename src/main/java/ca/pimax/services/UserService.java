package ca.pimax.services;

import java.util.List;
import ca.pimax.models.User;
import org.springframework.stereotype.Service;

import ca.pimax.repository.UserRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    public List<User> getAdmins(Integer limit, String search)
    {
        return userRepository.findAllAdmins(search, limit);
    }
    
}
