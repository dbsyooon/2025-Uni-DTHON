package practice.deploy.test.exception;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import practice.deploy.global.exception.errorcode.ErrorCode;

@Getter
@RequiredArgsConstructor
public class TestException extends RuntimeException {
    private final ErrorCode errorCode;
}

