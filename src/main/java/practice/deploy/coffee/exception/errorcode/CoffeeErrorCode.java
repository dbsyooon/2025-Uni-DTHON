package practice.deploy.coffee.exception.errorcode;

import lombok.Getter;
import org.springframework.http.HttpStatus;
import practice.deploy.global.exception.errorcode.ErrorCode;

@Getter
public enum CoffeeErrorCode implements ErrorCode {
    ;
    private HttpStatus httpStatus;
    private String message;
}
