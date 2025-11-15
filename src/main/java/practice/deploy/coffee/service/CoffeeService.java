package practice.deploy.coffee.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import org.springframework.transaction.annotation.Transactional;
import practice.deploy.coffee.domain.Coffee;
import practice.deploy.coffee.dto.request.CoffeeRequest;
import practice.deploy.coffee.dto.response.CoffeeItemResponse;
import practice.deploy.coffee.dto.response.CoffeeListResponse;
import practice.deploy.coffee.repository.CoffeeRepository;

import practice.deploy.user.domain.User;
import practice.deploy.user.exception.UserException;
import practice.deploy.user.repository.UserRepository;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.stream.Collectors;

import static practice.deploy.user.exception.errorcode.UserErrorCode.USER_NOT_FOUND;

@Service
@RequiredArgsConstructor
public class CoffeeService {

    private final CoffeeRepository coffeeRepository;
    private final UserRepository userRepository;

    @Transactional
    public void addCoffee(Long userId, CoffeeRequest request) {

        User user = findUserOrThrow(userId);
        LocalTime drinkTime = LocalTime.parse(request.drinkTime());

        Coffee coffee = Coffee.builder()
                .name(request.coffeeName())
                .caffeineAmount(request.caffeineAmount())
                .drinkTime(drinkTime)
                .drinkDate(request.drinkDate())
                .user(user)
                .build();
        coffeeRepository.save(coffee);
    }

    @Transactional(readOnly = true)
    public CoffeeListResponse getCoffeeList(LocalDate drinkDate, Long userId){
        User user = findUserOrThrow(userId);

        List<Coffee> coffeeList = coffeeRepository.findAllByUserIdAndDrinkDate(userId, drinkDate);
        List<CoffeeItemResponse> coffeeResponseList = coffeeList.stream()
                .map(CoffeeItemResponse::from)
                .collect(Collectors.toList());

        return CoffeeListResponse.from(coffeeResponseList);
    }

    private User findUserOrThrow(Long userId) {
        return userRepository.findById(userId).orElseThrow(()-> new UserException(USER_NOT_FOUND));
    }
}
