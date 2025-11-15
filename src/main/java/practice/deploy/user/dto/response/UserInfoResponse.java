package practice.deploy.user.dto.response;

import practice.deploy.user.domain.User;
import practice.deploy.user.domain.type.Gender;

public record UserInfoResponse(
        Gender gender,
        Long age
) {
    public static UserInfoResponse from(User user){
        return new UserInfoResponse(
                user.getGender(),
                user.getAge()
        );
    }
}
