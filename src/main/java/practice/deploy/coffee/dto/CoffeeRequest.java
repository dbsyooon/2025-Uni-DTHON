package practice.deploy.coffee.dto;

import java.time.LocalTime;

public record CoffeeRequest(
        Long userId,
        LocalTime drinkTime,
        String name,
        Long caffeineAmount
) {}
