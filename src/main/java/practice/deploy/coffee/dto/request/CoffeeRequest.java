package practice.deploy.coffee.dto.request;

public record CoffeeRequest(
        String drinkTime,
        String coffeeName,
        Long caffeineAmount
) {}
