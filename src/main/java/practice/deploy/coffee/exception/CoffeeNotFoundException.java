package practice.deploy.coffee.exception;

public class CoffeeNotFoundException extends RuntimeException {

    public CoffeeNotFoundException(Long id) {
        super("Coffee not found with id: " + id);
    }
}
