package practice.deploy.coffee.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import practice.deploy.coffee.dto.CoffeeRequest;
import practice.deploy.coffee.dto.CoffeeResponse;
import practice.deploy.coffee.service.CoffeeService;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/coffee")
public class CoffeeController {

    private final CoffeeService coffeeService;

    @PostMapping
    public CoffeeResponse create(@RequestBody CoffeeRequest request) {
        return coffeeService.save(request);
    }

    @GetMapping("/{id}")
    public CoffeeResponse getCoffeeById(@PathVariable Long id) {
        return coffeeService.getById(id);
    }

    @DeleteMapping("/{id}")
    public void deleteCoffee(@PathVariable Long id) {
        coffeeService.delete(id);
    }
}