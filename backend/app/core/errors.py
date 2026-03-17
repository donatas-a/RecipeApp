class APIException(Exception):
    def __init__(self, code: str, message: str, status_code: int = 400) -> None:
        self.code = code
        self.message = message
        self.status_code = status_code
        super().__init__(message)


class NotFoundException(APIException):
    def __init__(self, message: str = "Recipe not found") -> None:
        super().__init__(code="recipe_not_found", message=message, status_code=404)
