package practice.deploy.coffee.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import practice.deploy.coffee.domain.Coffee;
import practice.deploy.coffee.dto.CoffeeRequest;
import practice.deploy.coffee.dto.CoffeeResponse;
import practice.deploy.coffee.exception.CoffeeNotFoundException;
import practice.deploy.coffee.repository.CoffeeRepository;

import practice.deploy.user.domain.User;
import practice.deploy.user.exception.UserException;
import practice.deploy.user.repository.UserRepository;

@Service
@RequiredArgsConstructor
public class CoffeeService {

    private final CoffeeRepository coffeeRepository;
    private final UserRepository userRepository;

    public CoffeeResponse save(CoffeeRequest request) {

        User user = userRepository.findById(request.userId())
                .orElseThrow(() -> new UserException(request.userId()));

        Coffee coffee = new Coffee(
                user,
                request.drinkTime(),
                request.name(),
                request.caffeineAmount()
        );

        Coffee saved = coffeeRepository.save(coffee);

        return toResponse(saved);
    }

    public CoffeeResponse getById(Long id) {
        Coffee coffee = coffeeRepository.findById(id)
                .orElseThrow(() -> new CoffeeNotFoundException(id));

        return toResponse(coffee);
    }

    public void delete(Long id) {
        Coffee coffee = coffeeRepository.findById(id)
                .orElseThrow(() -> new CoffeeNotFoundException(id));

        coffeeRepository.delete(coffee);
    }

    private CoffeeResponse toResponse(Coffee coffee) {
        return new CoffeeResponse(
                coffee.id(),
                coffee.user(),
                coffee.drinkTime(),
                coffee.name(),
                coffee.caffeineAmount()
        );
    }
}
