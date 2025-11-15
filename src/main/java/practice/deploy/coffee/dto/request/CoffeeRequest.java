package practice.deploy.coffee.dto.request;

import java.time.LocalDate;

public record CoffeeRequest(
        LocalDate drinkDate,
        String drinkTime,
        String coffeeName,
        Long caffeineAmount
) {}
