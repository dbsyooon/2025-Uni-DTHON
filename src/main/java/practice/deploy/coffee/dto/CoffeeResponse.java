package practice.deploy.coffee.dto;

import java.time.LocalTime;

public record CoffeeResponse(
        Long id,
        Long userId,
        LocalTime drinkTime,
        String name,
        Long caffeineAmount
) {}

