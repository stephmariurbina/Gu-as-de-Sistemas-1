import { Body, Controller, HttpException, HttpStatus, Post } from '@nestjs/common';
import { LoginDto } from './dto/login.dto';
import { AuthService } from './auth.service';


@Controller('auth')
export class AuthController {

    constructor(private authservice: AuthService) { }

    @Post ('login')
    async login(
        @Body() data: LoginDto
    ){

     const usertoken = await this.authservice.ValidateUser(data);

   if (!usertoken) throw new HttpException('Invalid Credencials', HttpStatus.UNAUTHORIZED);

   return usertoken;
    }
}


