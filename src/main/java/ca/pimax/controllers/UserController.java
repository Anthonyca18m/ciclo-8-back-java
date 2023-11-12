package ca.pimax.controllers;

import java.util.List;
import java.util.Optional;

import ca.pimax.auth.RegisterRequest;
import ca.pimax.models.User;
import ca.pimax.requests.UserUpdateRequest;
import ca.pimax.services.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping
    public List<User> getAdminsAll( @RequestParam(required = false, defaultValue = "100") Integer limit, 
        @RequestParam(required = false, defaultValue = "") String search)
    {
        return userService.getAdmins(limit, search);
    }

    @GetMapping(path = "/{id}")
    public Optional<User> findById(@PathVariable Long id)
    {
        return userService.findById(id);
    }

    @PostMapping
    public void register(@Valid @RequestBody RegisterRequest request, HttpServletRequest rq) {
        userService.register(request, rq);
    }

    @PostMapping(path = "/{id}")
    public User updateById(@Valid @RequestBody UserUpdateRequest request, @PathVariable Long id, HttpServletRequest rq)
    {
        return userService.updateById(request, id, rq);
    }

    @DeleteMapping(path = "/{id}")
    public boolean deleteById(@PathVariable Long id, HttpServletRequest rq)
    {
        return userService.deleteById(id, rq);
    }


}
